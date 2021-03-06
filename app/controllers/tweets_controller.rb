class TweetsController < ApplicationController


    get '/tweets' do
        if logged_in?
            @user = current_user
            @tweets = Tweet.all
            erb :'/tweets/tweets'
        else  
            redirect :'/login'
        end
    end

    get '/tweets/new' do
        if logged_in?
            erb :'/tweets/create'
        else
            redirect :'/login'
        end
    end

    post '/tweets' do
        if params[:content].empty?
            redirect :'/tweets/new'
        else
            @tweet = Tweet.create(params)
            @user = current_user
            @user.tweets << @tweet
            redirect :"/tweets/#{@tweet.id}"
        end
    end

    get '/tweets/:id' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            erb :'/tweets/show'
        else
            redirect :'/login'
        end
        
    end

    get '/tweets/:id/edit' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            @user = current_user            
            if @tweet.user_id == @user.id
                erb :"/tweets/edit"
            else
                redirect :'/tweets'
            end
        else
            redirect :'/login'
        end
        
    end

    patch '/tweets/:id' do
        @tweet = Tweet.find_by_id(params[:id])
        if params[:content].blank?
            redirect :"/tweets/#{@tweet.id}/edit"
        else
            @tweet.update(content: params[:content])
            redirect :"/tweets/#{@tweet.id}"
        end
    end

    delete '/tweets/:id/delete' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            @user = current_user
            if @tweet.user_id == @user.id
                @tweet.delete
                redirect :'/tweets'
            end
        else
        redirect :'/login'
        end
    end



end
