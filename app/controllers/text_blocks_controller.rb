class TextBlocksController < ApplicationController
    
    def index
        @text_blocks = TextBlock.all
        @text_block = TextBlock.new
    end

    def new
        @text_block = TextBlock.new
    end

    def create
        @text_block = TextBlock.new(params[:text_block])
        
        if @text_block.save
            @text_block.address = Address.create
            redirect_to root_path
        else
            render 'index'
        end
    end

    def destroy
    end
end
