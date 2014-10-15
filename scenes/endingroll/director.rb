module Endingroll
  class Director

    def initialize
      @y = Window.height
      @dy = 1
      @font = Font.new(70, "HGP行書体", weight: true)
      @font1 = Font.new(50, "HGP行書体", weight: true)
      @font2 = Font.new(30, "HGP行書体", weight: true)
      @s_endingroll = Sound.new("sounds/endingroll.wav")
      @s_endingroll.loop_count = -1
      @f_bk = 1
    end

    def move
      @y -= @dy
    end

    def draw
      if @f_bk == 1
        @s_endingroll.play
        @f_bk = 0
      end
      Window.draw_font(200, calc_y(0),"HERO SHIJIMI", @font, color: [255,255,255] )
      Window.draw_font(310, calc_y(200),"Project Leader", @font2, color: [255,255,255] )
      Window.draw_font(250, calc_y(240),"TAKASHI OHTA", @font1, color: [255,255,255] )
      Window.draw_font(290, calc_y(340),"Project Subleader", @font2, color: [255,255,255] )
      Window.draw_font(190, calc_y(380),"RYOUMA HASHIMOTO", @font1, color: [255,255,255] )
      Window.draw_font(220, calc_y(480),"Head Desiger & Programmer", @font2, color: [255,255,255] )
      Window.draw_font(280, calc_y(520),"NATSUKI ITO", @font1, color: [255,255,255] )
      Window.draw_font(290, calc_y(620),"Senior Programmer", @font2, color: [255,255,255] )
      Window.draw_font(240, calc_y(660),"RYOTA TAKAHASHI", @font1, color: [255,255,255] )
      Window.draw_font(320, calc_y(760),"Programmer", @font2, color: [255,255,255] )
      Window.draw_font(240, calc_y(800),"SUNGSU MOON", @font1, color: [255,255,255] )
      Window.draw_font(200, calc_y(860),"HIROISHI TAKAYUKI", @font1, color: [255,255,255] )


      Window.draw_font(150, calc_y(1100),"SPECIAL THANKS", @font, color: [255,255,255] )
      Window.draw_font(190, calc_y(1300),"HIDEKAZU NOZAKA", @font1, color: [255,255,255] )
      Window.draw_font(205, calc_y(1400),"NOBUYUKI HONDA", @font1, color: [255,255,255] )
      Window.draw_font(205, calc_y(1500),"KENTA KUMOJIMA", @font1, color: [255,255,255] )
      Window.draw_font(195, calc_y(1600),"KUNIAKI IGARASHI", @font1, color: [255,255,255] )
      Window.draw_font(205, calc_y(1700),"TORU KURAHASHI", @font1, color: [255,255,255] )
      Window.draw_font(270, calc_y(1800),"KOU HONDA", @font1, color: [255,255,255] )
      Window.draw_font(200, calc_y(1900),"AKIRA WATANABE", @font1, color: [255,255,255] )
      Window.draw_font(220, calc_y(2000),"MAMORU IWATA", @font1, color: [255,255,255] )
      Window.draw_font(210, calc_y(2100),"KYOKO FUKUOKA", @font1, color: [255,255,255] )
     
    end

    def play
      move
      draw
    end

    def calc_y(offset_y)      
      y = (@y + offset_y) % 3000
      if y < -100
        return y + 2200
      else
        return y
      end
    end

  end
end
