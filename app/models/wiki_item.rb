class WikiItem < ActiveRecord::Base

  @@wiki_switches = {
    /'''([^']*)'''/ => '<b>\1</b>',
    /''([^']*)''/ => '<i>\1</i>',
    /^\{$/ => '<ul>',
    /^\[$/ => '<ol>',
    /^\*(.*)$/ => '<li>\1</li>',
    /^\]$/ => '</ol>',
    /^\}$/ => '</ul>',
    /^h1\. (.*)$/ => '<a name="\1"></a>' + "\n" + '<h1>\1</h1>',
    /^h2\. (.*)$/ => '<a name="\1"></a>' + "\n" + '<h2>\1</h2>',
    /^h3\. (.*)$/ => '<h3>\1</h3>',
    /^h4\. (.*)$/ => '<h4>\1</h4>',
    /^h5\. (.*)$/ => '<h5>\1</h5>',
    /^h6\. (.*)$/ => '<h6>\1</h6>',
    /^centre\. (.*)$/ => '<center>\1</center>',
    /^center\. (.*)$/ => '<center>\1</center>',
    /^youtube\. (.*)$/ => '<object width="640" height="385"><param name="movie" value="http://www.youtube.com/v/$1&hl=en_GB&fs=1&"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/\1&hl=en_GB&fs=1&" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="640" height="385"></embed></object>',
    /(\[\[([A-Za-z0-9_?: \/\-]+)\]\])/ => {:content => '= link_to "\1", :controller => :wiki, :action => "\1"', :inline => 'haml'},
    /\[([A-Za-z0-9_?: \/\-.&]+[^|])\]/ => '<a href="\1">\1</a>',
    /\[([^|]+)\|([A-Za-z0-9_?: \/\-.&]+)\]/ => '<a href="\2">\1</a>',
    /-{4}/ => '<hr />',
    /^$/ => '<br />'
  }

  def self.get_switches
    return @@wiki_switches
  end

  @@ref_page = <<eof
h1. Header 1
h2. Header 2
h3. Header 3

{
* List item 1
* List item 2
* List item 3
}

[
* Numbered 1
* Numbered 2
* Numbered 3
]

h3. Styling
'''Bold Text'''

''Italic Text''

'''''Both bold and italic'''''


h3. Links
[[Link to another wiki page]]

[Link to google|http://google.com]


h1. OMG Awesome ideas!
youtube. J8nuiCoYfk0
eof

  def self.get_standard_page(name)
    if name.downcase == "ref"
      return WikiItem.new(:name => "Ref", :content => @@ref_page)
    end
    return nil
  end

end
