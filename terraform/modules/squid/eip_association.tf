resource "null_resource" "eip_association" {
  depends_on = [aws_ecs_service.squid]

  provisioner "local-exec" {
    command = <<EOF
      # タスクARNが見つかるまで待機（タイムアウトも設定）
      TIMEOUT=300
      START_TIME=$SECONDS
      
      while true; do
        TASK_ARN=$(aws ecs list-tasks --cluster ${module.ecs_cluster.cluster_name} --query 'taskArns[0]' --output text)
        if [ "$TASK_ARN" != "None" ] && [ ! -z "$TASK_ARN" ]; then
          echo "タスクが見つかりました: $TASK_ARN"
          break
        fi
        
        ELAPSED_TIME=$(expr $SECONDS - $START_TIME)
        if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
          echo "タイムアウト: タスクが見つかりませんでした"
          exit 1
        fi
        
        echo "タスク待機中... (経過時間: $ELAPSED_TIME秒)"
        sleep 10
      done

      # タスクが実行状態になるまで待機
      aws ecs wait tasks-running --cluster ${module.ecs_cluster.cluster_name} --tasks $TASK_ARN

      # ENI IDを取得
      ENI_ID=$(aws ecs describe-tasks --cluster ${module.ecs_cluster.cluster_name} --tasks $TASK_ARN \
        --query 'tasks[0].attachments[0].details[?name==`networkInterfaceId`].value' --output text)

      if [ -z "$ENI_ID" ]; then
        echo "ENI IDの取得に失敗しました"
        exit 1
      fi

      echo "ENI ID: $ENI_ID を見つけました"
      aws ec2 associate-address --allocation-id ${aws_eip.squid.allocation_id} --network-interface-id $ENI_ID
    EOF
  }
}