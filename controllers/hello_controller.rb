class HelloController < ApplicationController
    def index
        @books = Book.all.page(params[:page]).per(2)
    end
end
