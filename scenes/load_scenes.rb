require_relative 'title/director'
require_relative 'game/director'
require_relative 'ending/director'
require_relative 'endingroll/director'

Scene.add_scene(Title::Director.new, :title)
Scene.add_scene(Game::Director.new, :game)
Scene.add_scene(Ending::Director.new, :ending)
Scene.add_scene(Endingroll::Director.new, :endingroll)