module Ending
  class Director
    def initialize
      @bg_img = Image.new(800, 600, C_WHITE)
      @i_ending = Image.load("images/ending.png")
      @s_ending = Sound.new("sounds/ending.wav")
      @f_bk = 1
    end

    def play
      if @f_bk == 1
        @s_ending.play
        @f_bk = 0
      end
      if Input.keyPush?(K_A)
        @s_ending.stop
        Scene.set_current_scene(:endingroll)
      end
      Window.draw(0, 0, @i_ending)
    end
  end
end
