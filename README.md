# desafio-dev-umbler
Este repositório contém o código da aplicação proposta como desafio pela Umbler em 05/07/2017

## Deployment

Pré-requisitos: 
- Docker instalado e devidamente configurado.
- Docker Compose instalado e devidamente configurado.
- Acesso à internet.

Passos:
- Clonar este repositório.
- Por default, a aplicação irá executar na porta 80. Caso deseje mudar, basta alterar a porta em "ports" no docker-compose.yml.
- Executar "docker-compose up -d" na raiz do repositório.
- A aplicação estará disponível na porta configurada.

## Outras considerações
- Para acessar o shell do container: "docker exec -i -t app-domain-explorer /bin/bash"
- Para executar os testes unitários, após acessar o shell, executar: "cd api; rake test"
- Para alterar o tempo de persistência dos dados na cache, alterar a variável REDIS_EXPIRE no arquivo api/api.env.
- Configurações de host e porta do Redis estão disponíveis em api/api.env.
- Se for necessário restartar o container da aplicação, pode-se utilizar: "docker restart app-domain-explorer"
