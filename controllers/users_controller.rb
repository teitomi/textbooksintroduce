class UsersController < ApplicationController

    def show
        @user = User.find(params[:id])
        @books = @user.books.all.page(params[:page]).per(5)
    end

end
