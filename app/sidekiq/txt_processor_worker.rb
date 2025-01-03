class TxtProcessorWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(file_path, user_id)
    puts "\n=== INICIANDO PROCESSAMENTO DO ARQUIVO ==="
    puts "Arquivo: #{file_path}"
    puts "Usuário ID: #{user_id}"
    
    begin
      user = User.find(user_id)
      puts "Usuário encontrado: #{user.email}"
      
      unless File.exist?(file_path)
        puts "ERRO: Arquivo não encontrado: #{file_path}"
        return
      end
      
      content = File.read(file_path, encoding: 'UTF-8')
      puts "\nConteúdo do arquivo:"
      puts content
      puts "\nTamanho do conteúdo: #{content.size} caracteres"
      
      # Divide o conteúdo em posts usando '---' como separador
      posts = content.split(/\n---\n/).map(&:strip).reject(&:empty?)
      puts "\nNúmero de posts encontrados: #{posts.size}"
      
      posts.each_with_index do |post_content, index|
        puts "\n=== PROCESSANDO POST #{index + 1} ==="
        
        begin
          # Divide o post em linhas
          lines = post_content.lines.map(&:strip)
          
          # O primeiro parágrafo é o título
          title = lines.shift.to_s.strip
          puts "Título encontrado: '#{title}'"
          
          if title.empty?
            puts "AVISO: Post #{index + 1} ignorado - título vazio"
            next
          end
          
          # Procura a linha de tags (deve começar com #)
          tag_line = lines.find { |line| line.match?(/^#/) }
          if tag_line
            puts "Linha de tags encontrada: '#{tag_line}'"
            lines.delete(tag_line)
          else
            puts "AVISO: Nenhuma linha de tags encontrada"
            tag_line = ""
          end
          
          # Extrai todas as tags da linha, incluindo tags com underscore
          tag_names = tag_line.scan(/#([a-zA-Z0-9_\-]+)/).flatten.map(&:downcase)
          puts "Tags extraídas: #{tag_names.inspect}"
          
          # Processa cada tag
          tag_records = []
          tag_names.each do |tag_name|
            begin
              # Remove caracteres inválidos e normaliza o nome
              normalized_name = tag_name.to_s
                                      .strip
                                      .downcase
                                      .gsub(/[^a-z0-9_\-]/, '')
                                      .gsub(/\s+/, '_')
              
              next if normalized_name.empty?
              
              # Primeiro tenta encontrar a tag
              tag = Tag.find_by("LOWER(name) = ?", normalized_name)
              
              # Se não encontrar, cria uma nova
              if tag.nil?
                puts "Criando nova tag: #{normalized_name}"
                tag = Tag.new(name: normalized_name)
                
                begin
                  tag.save!
                  puts "Tag criada com sucesso: #{tag.name} (ID: #{tag.id})"
                rescue ActiveRecord::RecordInvalid => e
                  puts "Erro ao criar tag: #{e.message}"
                  # Tenta salvar ignorando algumas validações
                  tag.save(validate: false)
                  if tag.persisted?
                    puts "Tag criada com validação reduzida: #{tag.name} (ID: #{tag.id})"
                  else
                    puts "Falha ao criar tag mesmo sem validações"
                    next
                  end
                end
              else
                puts "Tag existente encontrada: #{tag.name} (ID: #{tag.id})"
              end
              
              tag_records << tag if tag.persisted?
            rescue => e
              puts "ERRO ao processar tag '#{tag_name}': #{e.message}"
              puts e.backtrace
            end
          end
          
          puts "\nTags processadas: #{tag_records.size}"
          puts "Nomes das tags: #{tag_records.map(&:name).join(', ')}"
          
          # O resto é o conteúdo
          content = lines.join("\n").strip
          puts "\nConteúdo do post:"
          puts content
          
          if content.empty?
            puts "AVISO: Post #{index + 1} ignorado - conteúdo vazio"
            next
          end
          
          # Cria o post primeiro sem as tags
          begin
            post = user.posts.new(
              title: title,
              content: content,
              created_at: Time.current,
              updated_at: Time.current
            )
            
            # Salva o post
            if post.save
              puts "\nPost base criado com sucesso!"
              puts "ID: #{post.id}"
              puts "Título: #{post.title}"
              
              # Agora adiciona as tags uma por uma
              tag_records.each do |tag|
                begin
                  post.tags << tag unless post.tags.include?(tag)
                  puts "Tag '#{tag.name}' adicionada ao post"
                rescue => e
                  puts "ERRO ao adicionar tag '#{tag.name}' ao post: #{e.message}"
                end
              end
              
              puts "\nPost #{index + 1} finalizado com sucesso!"
              puts "ID: #{post.id}"
              puts "Título: #{post.title}"
              puts "Tags: #{post.tags.pluck(:name).join(', ')}"
            else
              puts "\nERRO ao salvar post:"
              puts post.errors.full_messages
            end
            
          rescue => e
            puts "\nERRO ao processar post #{index + 1}:"
            puts "Mensagem: #{e.message}"
            puts "Backtrace:"
            puts e.backtrace
          end
          
        rescue => e
          puts "\nERRO ao processar post #{index + 1}:"
          puts "Mensagem: #{e.message}"
          puts "Backtrace:"
          puts e.backtrace
        end
      end
      
      # Remove o arquivo temporário
      File.delete(file_path)
      puts "\n=== PROCESSAMENTO CONCLUÍDO COM SUCESSO ==="
      puts "Arquivo temporário removido: #{file_path}"
      
    rescue => e
      puts "\nERRO FATAL:"
      puts e.message
      puts e.backtrace
    end
  end
end