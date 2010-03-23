class WikiController < ApplicationController

  private
  def wiki_sub(str)
    switches = WikiItem::get_switches
    switches.keys.each {|k|
      if switches[k].class == String
        str.gsub! k, switches[k]
      elsif switches[k].class == Hash && (scn = str.scan(k).flatten).size > 0
        if switches[k][:inline]
          str.gsub! k, render_to_string(:inline => switches[k][:content].gsub('\1', scn[1]), :type => switches[k][:inline])
        end
      end
    }
    return str
  end

  public
  def view
    render :text => "" and return unless params[:name] && params[:name].size > 0
    @page = WikiItem.find_by_name(params[:name]) || WikiItem.new(:name => params[:name], :content => "")
    if params[:commit] && params[:content]
      @page.content = params[:content]
      @page.save
    end
    @text = []
    @text << render_to_string(:inline => "= link_to_remote :Edit, :url => {:controller => :wiki, :action => :edit, :id => '#{params[:name]}'}, :update =>:main_wiki_box", :type => :haml)
    @text << "<br /><br />"
    @text << "Empty page for #{params[:name]}" unless @page.content && @page.content.size > 0
    @page.content.split("\n").each {|l|
      @text << wiki_sub(l.gsub("\r", ""))
    }
    @text = @text.join("\n")
    @text.html_safe!
    render :partial => "view", :layout => true, :locals => {:page => @page, :text => @text}
  end

  def edit
    render :text => "" and return unless params[:name] && params[:name].size > 0
    @page = WikiItem.find_by_name(params[:name]) || WikiItem.new(:name => params[:name], :content => "")
    render :partial => "edit", :locals => {:page => @page}
  end

end
