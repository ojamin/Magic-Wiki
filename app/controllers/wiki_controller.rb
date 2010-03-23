class WikiController < ApplicationController
  
  include MagicWiki

  def view
    magic_wiki_do_setup params[:name]
    if params[:commit] && params[:content]
      begin
        if @magic_wiki_editable
          @page.content = params[:content]
          @page.save
        end
      rescue
      end
    end
    render :text => magic_wiki_display and return if params[:commit]
    render :text => magic_wiki_display, :layout => true and return
  end

  def edit
    begin
      if @magic_wiki_editable
        magic_wiki_do_setup params[:name]
        render :partial => "wiki/edit", :locals => {:page => @page} and return
      end
    rescue
    end
    render :text => "" and return
  end

end
