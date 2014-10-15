module Title
  class Director
    def initialize
      @bg_img = Image.load("images/start.png")
      @s_opening  = Sound.new("sounds/opening.wav")
      @f_bk = 1
    end
    def play
      if @f_bk == 1
        @s_opening.play
        @f_bk = 0
      end  
      Window.draw(0, 0, @bg_img)
      if Input.keyPush?(K_SPACE)
        @s_opening.stop
        Scene.set_current_scene(:game)
      end
    end
  end
end
