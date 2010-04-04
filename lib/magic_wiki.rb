# class ApplicationController <
#class ActionController::Base
module MagicWiki
  require "haml"

  def magic_wiki_sub(str)
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

  def magic_wiki_do_setup(name)
    render :text => "" and return unless name.size > 0
    @page = WikiItem.get_standard_page(name) || WikiItem.find_by_name(name) || WikiItem.new(:name => name, :content => "")
  end

  def magic_wiki_display
    render :text => "" and return unless @page
    @text_start = []
    @text = []
    begin
      if @magic_wiki_editable
        @text_start << render_to_string(:inline => "= link_to_remote :Edit, :url => {:controller => :wiki, :action => :edit, :id => '#{@page.name}'}, :update => :main_wiki_box", :type => :haml)
        @text_start << "<br /><br />"
      end
    rescue
    end
    if @page.generated
      @text = @page.generated
    else
      @text << "Empty page for #{@page.name}" unless @page.content && @page.content.size > 0
      @page.content.split("\n").each {|l| @text << magic_wiki_sub(l.gsub("\r", "")) }
      @text = @text.join("\n")
      @page.generated = @text
      @page.save
    end
    @text = @text_start.join("\n") + @text
    @text.html_safe!
    outp = render_to_string(:partial => "wiki/view", :locals => {:page => @page, :text => @text}, :type => :haml)
    return ('<div id="main_wiki_box">' + outp + '</div>').html_safe!
  end

end
