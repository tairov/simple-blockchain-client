[
    {
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${project}-${env}-log-group-1",
                "awslogs-region": "${region}",
                "awslogs-stream-prefix": "client_service"
            }
        },
        "portMappings": [
            {
                "hostPort": 5001,
                "protocol": "tcp",
                "containerPort": 5001
            }
        ],
        "image": "${image}:${tag}",
        "name": "client_service"
    }
]
