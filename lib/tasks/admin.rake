namespace :admin do
  desc "Torna um usuário administrador pelo email"
  task :grant, [ :email ] => :environment do |t, args|
    if args[:email].blank?
      puts "Por favor, forneça um email. Exemplo: rake admin:grant[usuario@exemplo.com]"
      next
    end

    user = User.find_by(email: args[:email])

    if user
      user.update(admin: true)
      puts "Usuário #{user.email} agora é um administrador!"
    else
      puts "Usuário não encontrado com o email #{args[:email]}"
    end
  end

  desc "Lista todos os administradores"
  task list: :environment do
    admins = User.where(admin: true)

    if admins.any?
      puts "\nAdministradores atuais:"
      puts "----------------------"
      admins.each do |admin|
        puts "#{admin.email} (#{admin.username})"
      end
    else
      puts "Não há administradores cadastrados."
    end
  end
end
