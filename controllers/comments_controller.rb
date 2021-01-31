class CommentsController < ApplicationController
    before_action :authenticate_user!

    def create
        book = Book.find(params[:book_id])
        comment = book.comments.build(comment_params)
        comment.user_id = current_user.id
        if comment.save
            flash[:success] = "コメントしました"
            redirect_back(fallback_location: root_path)
        else
            flash[:success] = "コメントできませんでした"
            redirect_back(fallback_location: root_path)
        end
    end

    def destroy
        comment = Comment.find_by(book_id: params[:book_id], id: params[:id])
        comment.destroy
        redirect_back(fallback_location: root_path)
    end

    private
        def comment_params
            params.require(:comment).permit(:content)
        end


end
