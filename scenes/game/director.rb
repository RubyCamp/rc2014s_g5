module Game
  class Director

    def initialize
      @i_gameover_bk = Image.new(800, 600, [150, 40, 0, 0])
      @i_gameover = Image.load("images/gameover.png")

      @i_black = Image.load("images/black.png")
      @i_white = Image.load("images/white.png")
      @i_black2 = Image.load("images/black2.png")
      @i_white2 = Image.load("images/white2.png")
      @i_bomb   = Image.load("images/bomb.png")
      @i_effect = Image.load("images/effect.png")
      @i_victory = Image.load("images/victory.png")

      @s_bomb1  = Sound.new("sounds/bomb1.wav")
      @s_bomb2  = Sound.new("sounds/bomb2.wav")
      @s_bomb3  = Sound.new("sounds/bomb3.wav")
      @s_button = Sound.new("sounds/button.wav")

      # GRIDオセロ線引き処理
      @img = Image.new(800, 600, C_GREEN)
      grid_width  = 600 / 8
      grid_height = 600 / 8 
      9.times do |i|
        @img.line(i * grid_width , 0 , i * grid_width, 600 , C_BLACK)
        @img.line(0, i * grid_height , 600 , i * grid_height , C_BLACK)
      end

      @img.circle_fill(150,150,5,C_BLACK)
      @img.circle_fill(450,150,5,C_BLACK)
      @img.circle_fill(150,450,5,C_BLACK)
      @img.circle_fill(450,450,5,C_BLACK)

      @f_bk = 1
      @s_bk  = Sound.new("sounds/game.wav")
      @s_bk.loop_count = -1

      # パスボタン
      #@passbutton = Image.new(150, 50, C_RED)
      @i_pass = Image.load("images/buy-now-button2.png")

      # 爆弾クリア処理カウント
      @bomb_display_count = 0

      # 爆弾数
      @b_black = 1
      @b_white = 1

      # フォントの定義
      @font = Font.new(40, "HGP行書体", weight: true)

      # オセロの２次元配列：[1]黒 [2]白 [9]壁
      @othello = [
        [9,9,9,9,9,9,9,9,9,9],
        [9,0,0,0,0,0,0,0,0,9],
        [9,0,0,0,0,0,0,0,0,9],
        [9,0,0,0,0,0,0,0,0,9],
        [9,0,0,0,1,2,0,0,0,9],
        [9,0,0,0,2,1,0,0,0,9],
        [9,0,0,0,0,0,0,0,0,9],
        [9,0,0,0,0,0,0,0,0,9],
        [9,0,0,0,0,0,0,0,0,9],
        [9,9,9,9,9,9,9,9,9,9]
      ]

      # 白黒順番設定
      @order = 0
      #ランダム地雷 
      @bx = rand(8)+1; @by = rand(8)+1
      @f_bomb = 1
      p @bx
      p @by
    end 

    # 配列座標の判定
    def getPoint(point)
      case point
        when (0...75) 
        1
        when (75...150) 
        2
        when (150...225)
        3
        when (225...300)
        4
        when (300...375)
        5
        when (375...450)
        6
        when (450...525)
        7
        when (525...600)
        8
        else
        0
      end
    end

    #判定
    def okeruka(x,y)
      player = @order + 1
      enemy  = (~@order & 1) +1 
      if @othello[x][y] != 0
        return false
      end
      (-1..1).each do |dx|
        (-1..1).each do |dy|
          if dx==0 && dy==0
            next
          end
          nx = x + dx
          ny = y + dy
          if @othello[nx][ny] != enemy
            next 
          end

          begin 
            nx += dx
            ny += dy
          end while @othello[nx][ny] == enemy

          if @othello[nx][ny] == player
            return true
          end

        end
      end
      return false
    end

    #ひっくりかえす
    def hikkurikaesu(x,y)
      player = @order + 1
      enemy  = (~@order & 1) + 1

      (-1..1).each do |dx|
        (-1..1).each do |dy|
          if dx==0 && dy==0
            next
          end
          nx = x + dx
          ny = y + dy
          if @othello[nx][ny] != enemy
            next 
          end
          begin 
            nx += dx
            ny += dy
          end while @othello[nx][ny] == enemy

          if @othello[nx][ny] == player
            nx -= dx
            ny -= dy
            while @othello[nx][ny] != player
              @othello[nx][ny] = player
              nx -= dx
              ny -= dy
            end
          end
        end 
     end
    end


##################
#終局判定メソッド
def owari()
  @order = ~@order & 1
  (1..8).each do |x|
    (1..8).each do |y|
      if(okeruka(x,y) == true || @othello[x][y]  > 2)
        @order = ~@order & 1
        return false
      end
    end
  end

  @order = ~@order & 1
  (1..8).each do |x|
    (1..8).each do |y|
      if(okeruka(x,y) == true)
        return false
      end
    end
  end

  return true
end
##############


    def play

      if @f_bk == 1
        @s_bk.play
        @f_bk = 0
      end 

      # オセロ画面の表示
      Window.draw(0, 0, @img)
      #Window.draw(625, 525, @passbutton)
      Window.drawScale( 420, 485, @i_pass, 0.5 , 0.5)

      pos_x = Input.mouse_pos_x
      pos_y = Input.mouse_pos_y
      x = getPoint(pos_x);
      y = getPoint(pos_y);

      # マウス左クリック時の処理
      if Input.mouse_push?(M_LBUTTON) 
        x = getPoint(Input.mouse_pos_x);
        y = getPoint(Input.mouse_pos_y);
    
        # 石を置ける場合
        if okeruka(x,y) == true
          # 地来の場合
          if x == @bx && y == @by && @f_bomb == 1
            @bomb_display_count = 60
            @s_bomb3.play
            @f_bomb = 0
            (1..8).each do |i|
              (1..8).each do |j|
                if i != x
                   j = y
                end
                if x == i && y == j
                  @othello[i][j] = 3
                else
                  @othello[i][j] = 4
                end
              end
            end
            @order = ~@order & 1
          # その他  
          else
            @othello[x][y] = @order + 1;
            # 白黒反転処理
            if @order == 0 then
              @s_bomb1.play
            else
              @s_bomb2.play
            end
            hikkurikaesu(x,y)
            @order = ~@order & 1
          end
        end

        # パスボタンの処理
        if (pos_x >= 610) && (pos_x <= 780) && (pos_y >= 530) && (pos_y <= 580)
          @s_button.play
          @order = ~@order & 1
        end
      end


      # マウス右クリック時の処理
      if Input.mouse_push?(M_RBUTTON) 
        if @othello[x][y] == 0
          if (@order == 0 && @b_black == 1) || (@order == 1 && @b_white == 1)
            @bomb_display_count = 60
            @othello[x][y] = 3;
            @s_bomb3.play
            if @order == 0
              @b_black = 0
            elsif @order == 1
              @b_white = 0
            end
            @order = ~@order & 1
            (-1..1).each do |i| 
              (-1..1).each do |j|
                if @othello[x+i][y+j] == 9 || (i==0 && j==0)
                  next
                end
                @othello[x+i][y+j] = 4
              end
            end
          end
        end
      end

      # 爆弾クリア用
      if @bomb_display_count > 0
        @bomb_display_count -= 1
      end
      if @bomb_display_count <= 0
        (1..8).each do |x|
          (1..8).each do |y|
            if @othello[x][y] == 3 or @othello[x][y] == 4 
              @othello[x][y] = 0
            end
          end
        end
      end

      c_black = 0
      c_white = 0
      # オセロ画面の「白黒」更新処理
      (1..8).each do |x|
        (1..8).each do |y|
          if @othello[x][y] == 1 then
            c_black = c_black + 1
          elsif @othello[x][y] == 2 then
            c_white = c_white + 1
          end
        end
      end

      Window.draw_font(615, 35, "黒#{c_black}", @font, color: [0,0,0] )
      Window.draw_font(710, 35, "白#{c_white}", @font, color: [255,255,255] )
      Window.draw_font(615, 80, "爆#{@b_black}", @font, color: [0,0,0] )
      Window.draw_font(710, 80, "爆#{@b_white}", @font, color: [255,255,255] )
      Window.draw(650, 160, @i_victory)

      if @order == 0 then
        Window.draw(640, 330, @i_black2)
      elsif @order == 1 then
        Window.draw(640, 330, @i_white2)
      end

      # オセロ画面の更新処理
      (1..8).each do |x|
        (1..8).each do |y|
          case @othello[x][y]  
            when 1
              Window.draw(((x-1)*75)+1, ((y-1)*75)+1, @i_black)
            when 2
              Window.draw(((x-1)*75)+1, ((y-1)*75)+1, @i_white)
            when 3
              Window.draw(((x-1)*75)+1, ((y-1)*75)+1, @i_bomb)
            when 4
              Window.draw(((x-1)*75)+1, ((y-1)*75)+1, @i_effect)
          end
        end
      end

      # ゲームオーバー
      #if (c_black == 0) || (c_white == 0) || (c_black + c_white == 64)
      if (owari() == true) 
        @s_bk.stop
        #Window.draw(0, 0, @i_gameover_bk)
        Window.draw(13, 200, @i_gameover)
        Scene.add_scene(Game::Director.new, :game) if Input.keyPush?(K_R)
      end

      # ゲーム修了ボタン[E]
      if Input.keyPush?(K_E)
        @s_bk.stop
        Scene.set_current_scene(:ending)
      end

    end

  end
end
