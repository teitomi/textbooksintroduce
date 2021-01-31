class BooksController < ApplicationController

    before_action :authenticate_user!, only: [:new, :create]

    def index
        if params[:search] == nil
            @books = Book.all.page(params[:page]).per(5)
        elsif params[:search] == ''
            @books = Book.all.page(params[:page]).per(5)
        else
            keywords = params[:search].split(/[[:blank:]]+/).select(&:present?)
            keywords.each do |keyword|
                @books = Book.where(['title LIKE ? OR subject LIKE ? OR review LIKE ? OR suitable LIKE ?', '%' + keyword + '%', '%' + keyword + '%', '%' + keyword + '%', '%' + keyword + '%']).page(params[:page]).per(5)
                print("search")
            end
        end 
        @comment = Comment.new
    end

    def new
        @book = Book.new
    end

    def create
        book = Book.new(book_params)
        book.user_id = current_user.id
        if book.save
            redirect_to :action => "index"
        else
            redirect_to :action => "new"
        end
    end

    def show
        @book = Book.find(params[:id])
        @comments = @book.comments
        @comment = Comment.new
    end

    def edit
        @book = Book.find(params[:id])
    end

    def update
        book = Book.find(params[:id])
        if book.update(book_params)
            redirect_to :action => "show", :id => book.id
        else
            redirect_to :action => "new"
        end
    end

    def destroy
        book = Book.find(params[:id])
        book.destroy
        redirect_to action: :index
    end

    private
    def book_params
        params.require(:book).permit(:title, :subject, :suitable, :review, :image)
    end

end
