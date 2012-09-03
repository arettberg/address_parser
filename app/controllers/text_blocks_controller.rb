class TextBlocksController < ApplicationController
    
    include TextBlocksHelper
    
    def index
        @text_blocks = TextBlock.all
        @text_block = TextBlock.new
    end

    def new
        @text_block = TextBlock.new
    end

    def create
        @text_block = TextBlock.new(params[:text_block])
        parsed_hash = parse_address_text(@text_block.text)
        
        #write errors to flash
        if(parsed_hash[:errors].any?)
            flash[:warning] = parsed_hash[:errors]
        end
        
        @address = Address.new(parsed_hash[:address])

        
        if @address.save 
            @text_block.address = @address
            if @text_block.save
                redirect_to root_path
            else
                @address.destroy
                @text_blocks = TextBlock.all
                render 'index'
            end
        else
            @text_blocks = TextBlock.all
            render 'index'
        end
    end

    def destroy
    end
end
