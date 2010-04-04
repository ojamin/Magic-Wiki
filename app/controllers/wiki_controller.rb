class WikiController < ApplicationController
  
  include MagicWiki

  private
  def h(text)
    return CGI.escapeHTML text
  end

  public
  def view
    magic_wiki_do_setup h(params[:name])
    if params[:commit] && params[:content]
      tcontent = h(params[:content])
      begin
        tcontent = params[:content] if @magic_wiki_allow_html == true
      rescue
      end

      begin
        if @magic_wiki_editable == true
          @page.content = tcontent
          @page.generated = nil
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
        magic_wiki_do_setup h(params[:name])
        render :partial => "wiki/edit", :locals => {:page => @page} and return
      end
    rescue
    end
    render :text => "" and return
  end

end
