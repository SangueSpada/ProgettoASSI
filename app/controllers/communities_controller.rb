class CommunitiesController < ApplicationController
    skip_before_action :verify_authenticity_token

    def new
        @tags = Tag.all
        @community = Community.new()
    end

    def create
        @community = Community.new(community_params)
        #give_community_tags(@community, params[:tag_ids])
        if @community.save
            @participation = Participation.new(role: :admin)
            if @participation.save
                redirect_to root_path
            else
                render :new, status: :unprocessable_entity
            end
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @tags = Tag.all
        @community = Community.find(params[:id])
    end

    def update
        @community = Community.find(params[:id])
        if @community.update(community_params)
            redirect_to root_path
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @community = Community.find(params[:id])
        @community.destroy

        redirect_to root_path, status: :see_other
    end

    private
        def community_params
            params.require(:community).permit(:name, :creator, :description, :playlist)
        end

        def give_community_tags(community, tags)
            tags.each do |tag|
                community.tags << Tag.find(id: tag)
            end
        end
end
