# Blog - Plataforma de Compartilhamento de Conteúdo

![Ruby](https://img.shields.io/badge/Ruby-3.2.2-red)
![Rails](https://img.shields.io/badge/Rails-7.1.2-red)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Latest-blue)
![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3-purple)

Uma plataforma moderna e intuitiva para compartilhamento de conteúdo, desenvolvida com Ruby on Rails. O projeto oferece uma experiência rica para criação e interação com posts, sistema de tags, e uma comunidade ativa.

## 🚀 Funcionalidades

### Para Usuários não Logados
- Visualização de posts ordenados por data (mais recentes primeiro)
- Paginação automática (3 posts por página)
- Sistema de comentários anônimos
- Cadastro de nova conta
- Recuperação de senha

### Para Usuários Logados
- Criação, edição e exclusão de posts
- Sistema de tags para categorização de conteúdo
- Comentários identificados
- Gerenciamento de perfil
- Alteração de senha

## 👥 Gerenciamento de Administradores

Para gerenciar administradores do sistema, use os seguintes comandos:

```bash
# Tornar um usuário administrador
rails admin:grant[email@exemplo.com]

# Listar todos os administradores
rails admin:list
```

Administradores têm acesso a funcionalidades adicionais como:
- Gerenciamento de tags
- Moderação de comentários
- Visualização de estatísticas

## 💻 Tecnologias Utilizadas

- **Backend:**
  - Ruby 
  - Rails 
  - PostgreSQL
  - Devise (Autenticação)
  - Kaminari (Paginação)
  - Sidekiq (Processamento Assíncrono)

- **Frontend:**
  - Bootstrap 
  - CSS
  - JavaScript
  - Stimulus.js

## 🛠️ Configuração do Ambiente

### Pré-requisitos
- Ruby 
- PostgreSQL
- Node.js
- Yarn
- Redis (para Sidekiq)

### Instalação

1. Clone o repositório
```bash
git clone https://github.com/joaomgsb/blog.git
cd blog
```

2. Instale as dependências
```bash
bundle install
yarn install
```

3. Configure o banco de dados
```bash
rails db:create
rails db:migrate
```

4. Inicie o servidor
```bash
rails server
```

5. Inicie o Sidekiq (em outro terminal)
```bash
bundle exec sidekiq
```

O aplicativo estará disponível em `http://localhost:3000`

## 🌟 Recursos Especiais

### Sistema de Tags
- Categorização eficiente de posts
- Filtros por tags
- Interface intuitiva para gerenciamento

### Upload de Arquivos
- Suporte para processamento assíncrono via Sidekiq
- Upload de arquivos TXT para criação em massa de posts/tags

### Internacionalização
- Suporte completo para múltiplos idiomas
- Interface adaptável

## 📱 Design Responsivo

O blog foi desenvolvido com foco em:
- Design Mobile First
- Interface limpa e moderna
- Experiência de usuário otimizada
- Acessibilidade

## 🔍 Testes

O projeto inclui:
- Testes unitários
- Testes de integração
- Testes de sistema

Para executar os testes:
```bash
rails test
```

## 🚀 Deploy

O projeto está configurado para deploy na plataforma Render, oferecendo:
- Integração contínua
- Deploy automático
- Monitoramento de performance

## 📝 Boas Práticas

O código segue:
- Princípios SOLID
- Padrões Rails de convenção sobre configuração
- Código limpo e bem documentado
- Commits semânticos

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📫 Contato

João Mateus - [joaomgsb@gmail.com](mailto:joaomgsb@gmail.com)

Link do projeto: [https://github.com/joaomgsb/blog](https://github.com/joaomgsb/blog)

## 📄 Licença

Este projeto está sob a licença MIT - veja o arquivo [LICENSE.md](LICENSE.md) para detalhes.

---
⭐️ Desenvolvido como parte do processo seletivo para estágio na Mainô
