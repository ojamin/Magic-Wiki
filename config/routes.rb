ActionController::Routing::Routes.draw do |map|
  map.connect 'wiki/edit/:name', :controller => :wiki, :action => :edit
  map.connect 'wiki/update/:name', :controller => :wiki, :action => :update
  map.connect 'wiki/:name', :controller => :wiki, :action => :view
end
