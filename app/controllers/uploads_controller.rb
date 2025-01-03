class UploadsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    Rails.logger.info "Iniciando upload do arquivo..."
    
    if params[:file].present?
      Rails.logger.info "Content Type: #{params[:file].content_type}"
      
      if params[:file].content_type == 'text/plain'
        begin
          # Salva o arquivo temporariamente
          temp_file = Rails.root.join('tmp', "posts_#{Time.current.to_i}.txt")
          Rails.logger.info "Salvando arquivo temporário em: #{temp_file}"
          
          # Lê o conteúdo do arquivo e converte para UTF-8
          content = params[:file].read
          Rails.logger.info "Arquivo lido, tentando converter encoding..."
          
          content = content.force_encoding('UTF-8')
          
          # Se ainda não é válido UTF-8, tenta converter de outras codificações comuns
          unless content.valid_encoding?
            Rails.logger.info "Tentando outras codificações..."
            ['Windows-1252', 'ISO-8859-1'].each do |encoding|
              begin
                content = params[:file].read.force_encoding(encoding).encode('UTF-8')
                if content.valid_encoding?
                  Rails.logger.info "Convertido com sucesso usando #{encoding}"
                  break
                end
              rescue Encoding::InvalidByteSequenceError, Encoding::UndefinedConversionError => e
                Rails.logger.error "Erro ao converter usando #{encoding}: #{e.message}"
                next
              end
            end
          end
          
          # Se ainda não conseguiu converter, retorna erro
          unless content.valid_encoding?
            Rails.logger.error "Não foi possível converter o arquivo para UTF-8"
            flash.now[:alert] = 'O arquivo precisa estar em UTF-8 ou outro formato de texto válido.'
            return render :new
          end
          
          # Salva o conteúdo convertido
          File.write(temp_file, content)
          Rails.logger.info "Arquivo temporário salvo com sucesso"
          
          # Envia para processamento assíncrono
          TxtProcessorWorker.perform_async(temp_file.to_s, current_user.id)
          Rails.logger.info "Trabalho enviado para processamento assíncrono"
          
          redirect_to posts_path, notice: 'Arquivo recebido! Os posts serão criados em breve.'
        rescue => e
          Rails.logger.error "Erro durante o processamento do arquivo: #{e.message}"
          Rails.logger.error e.backtrace.join("\n")
          flash.now[:alert] = 'Ocorreu um erro ao processar o arquivo. Por favor, tente novamente.'
          render :new
        end
      else
        Rails.logger.error "Tipo de arquivo inválido: #{params[:file].content_type}"
        flash.now[:alert] = 'Por favor, selecione um arquivo TXT válido.'
        render :new
      end
    else
      Rails.logger.error "Nenhum arquivo foi enviado"
      flash.now[:alert] = 'Por favor, selecione um arquivo TXT válido.'
      render :new
    end
  end
end 