; CoordMode, Mouse , Screen
; #Include %A_ScriptDir%\Gdip_All.ahk

/* ***** FATTZ - FancyAssToolTipZ *****
	@@@ Description: 	Fancy Tooltips with customizeable visual elements and a title section
	@@@ Version: 		0.5.0
	@@@ Author: 		W3ap0n-X 

	@@@ Requirements: 	Autohotkey v1.1.33.02+	|	Gdip_All.ahk (https://github.com/marius-sucan/AHK-GDIp-Library-Compilation/blob/master/ahk-v1-1/Gdip_All.ahk)
	@@@ Notes: 
		@@@				Make sure Gdip_All.ahk is included in your script or include it at the top of this script
		@@@				Following Coord-mode is required for mouse tracking: """CoordMode, Mouse , Screen  """

*/
Class FancyAssToolTipZ {
	CallSign := "FancyAssToolTipZ"
	Timeout := 3000
	Title := False
	BackGround := False
	Count := 0
	Pos := False
	Running := False
	pToken := False
	xOffset := 8
	yOffset := 12

	Class _Info {
		Version := "0.5.0"
		ClassName := "FancyAssToolTipZ"
		ClassDescription := "It do what it say on da tin. Colors, Titles, Borders and Backgrounds! Oh my!"
	}

	Class _Settings {
		; 
	}

	__New(CallSign){
		this.CallSign := CallSign
		this.Msg := new this.TxtBox()
		this.Title := new this.TxtBox()
		
		this.DestroyTT := ObjBindMethod(this , "GuiDestroy")
	}

	StartUp(CallSign){
		this.CallSign := CallSign
		this.Msg := new this.TxtBox()
		this.Title := new this.TxtBox()
		this.Timeout := 3000
		this.DestroyTT := ObjBindMethod(this , "GuiDestroy")
		this.xOffset := 8
		this.yOffset := 12

	}

	A( Msg, Title := "" , Timeout := "" , MsgColor := "" , TitleColor := "" ) {
		If (! this.CallSign) {
			this.StartUp("FancyAssToolTipZ")
		}
		If (!Timeout) {
			Timeout := this.Timeout
		}

		If (this.Running){
			this.GuiDestroy()
		}
		this.Msg.A(Msg)
		If (Title){
			this.Title.A(Title)
			this.Msg.yPos := this.Title.Height - (this.Msg.Border.Size)
			If ( this.Title.Width <= this.Msg.Width ) {
				this.Title.Width := this.Msg.Width
				this.Title.Text.Width := this.Msg.Text.Width
			} Else {
				this.Msg.Width := this.Title.Width
				this.Msg.Text.Width := this.Title.Text.Width
			}
		}

		this.Running := this.GuiSetup(This.CallSign)
		
		
		this.Run(Timeout)
		; GuiWidth := ( this.Title["Width"] >= this.Msg["Width"] ) ? this.Title["Width"] : this.Msg["Width"]
		; this.Msg["Height"] := this.Msg["Height"] + this.Title["Height"] 

	}

	Run(Timeout := ""){
		If (!Timeout) {
			Timeout := this.Timeout
		}
		
		DestroyTT := this.DestroyTT
		this.GraphicsRender(this.Running) 
		SetTimer, % DestroyTT, %Timeout%

	}

	GuiSetup(CallSign) {
		Gui, %CallSign%:New, % "-DPIScale -Caption +AlwaysOnTop +ToolWindow +E0x80000 +Disabled +OwnDialogs HWNDTTHWND", % CallSign
    	Gui, %CallSign%:Show, % "x" . this.MPOS_X(5) . "y" . this.MPOS_Y(5) . " NoActivate"

		Return TTHWND
	}

	GuiDestroy(){
		DestroyTT := this.DestroyTT
		SetTimer, % DestroyTT, Off
		CallSign := this.CallSign
		Gui, %CallSign%:Destroy
		this.Running := False
		this.pToken := False
		this.Graphics := False
		this.hdc := False
	}

	TotalWidth(){
		TotalW := 0
		If (this.BackGround) {
			TotalW := (TotalW <= this.BackGround.Width) ? this.BackGround.Width : TotalW
		}
		If (this.Title) {
			TotalW := (TotalW <= this.Title.Width) ? this.Title.Width : TotalW
		}
		If (this.Msg) {
			TotalW := (TotalW <= this.Msg.Width) ? this.Msg.Width : TotalW
		}
		Return TotalW
	}
	
	TotalHeight(){
		TotalH := 0
		If (this.BackGround) {
			TotalH := (TotalH <= this.BackGround.Height) ? this.BackGround.Height : TotalH
		}
		If (this.Title) {
			TotalH := (TotalH <= this.Title.Height) ? this.Title.Height : TotalH
		}
		If (this.Msg) {
			; If(TotalH <= this.Msg.Height)
			TotalH := (TotalH <= (this.Msg.Height + this.Msg.yPos) ) ? (this.Msg.Height + this.Msg.yPos) : TotalH
		}
		Return TotalH
	}

	GraphicsRender(hwnd) {
		if (!this.pToken) {
			this.pToken := Gdip_Startup()
		}
		; msgbox % this.pToken
		tmpwidth := ( this.Title["Width"] >= this.Msg["Width"] ) ? this.Title["Width"] : this.Msg["Width"]
		tmpheight := (this.Title["Height"]) ? ( this.Msg["Height"] + this.Title["Height"] ) : this.Msg["Height"]
		; MsgBox % tmpwidth
		; MsgBox % tmpheight . " : "  . this.Msg["Height"]  
		hbm := CreateDIBSection(tmpwidth, tmpheight)
		; hbm := CreateDIBSection(this.TotalWidth(), this.TotalHeight())
		hdc := CreateCompatibleDC()
		obm := SelectObject(hdc, hbm)
		Graphics := Gdip_GraphicsFromHDC(hdc)
		
		Gdip_SetSmoothingMode(this.Graphics, 4)

		If (this.BackGround) {

		}
		If (this.Msg) {
			this.Msg.Render(Graphics)
		}


		If (this.Title) {
			this.Title.Render(Graphics)
		}
		
		UpdateLayeredWindow(this.Running, hdc, this.MPOS_X(this.xOffset), this.MPOS_Y(this.yOffset), tmpwidth, tmpheight)

		SelectObject(hdc, obm)
		DeleteObject(hbm)
		DeleteDC(hdc)
		Gdip_DeleteGraphics(Graphics)
	}
	
	MPOS_X(offset:=""){
		MouseGetPos, x
		x += offset
		Return x
	}

	MPOS_Y(offset:=""){
		MouseGetPos, , y
		y += offset
		Return y
	}
	
	Class BackBox {
		__New(){
			this.Background := new this._BackGround(this)
			this.Border := new this._Border(this)
		}

		A(){
			;
		}

		Class _BackGround {
			Color := "1C1C1C"
			Opacity := "BB"
			Padding := 0
			; Margin := 0

			__New(byref Parent) {
				this.parent := Parent
			}

			xPos() {
				x_pos := 0
				x_pos += this.parent.xPos
				x_pos += ( this.parent.Border.Padding >= 0 ? this.parent.Border.Padding * 1 : 0 )
				; x_pos += this.parent.Background.Padding * 1 
				return x_pos
			}

			yPos() {
				y_pos := 0
				y_pos += this.parent.yPos
				y_pos += ( this.parent.Border.Padding >= 0 ? this.parent.Border.Padding * 1 : 0 )
				; y_pos += this.parent.Background.Padding * 1 
				return y_pos
			}

			wPos() {
				pos := this.parent.Width - ( this.parent.Border.Padding >= 0 ? this.parent.Border.Padding * 2 : 0 )
				return pos
			}

			Render(byref G) {
				pBrush := Gdip_BrushCreateSolid( "0x" . this.Opacity . this.Color )
				Gdip_FillRectangle(G, pBrush, this.xPos(), this.yPos(), this.wPos(), this.parent.Height - (this.parent.Border.Padding >= 0 ? this.parent.Border.Padding * 2 : 0) )
				Gdip_DeleteBrush(pBrush)
			}
		}

		Class _Border {
			Size := 1
			Padding := 0
			Color := "8C8C8C"
			Opacity := "AA"

			__New(byref Parent) {
				this.parent := Parent
			}

			xPos(){
				Pos := 0 
				Pos += this.Size/2
				if (this.Padding < 0 ) {
					pos += this.Padding *-1
				}
				return Pos
			}

			yPos(){
				Pos := 0 
				Pos += this.Size/2
				Pos += this.parent.yPos
				if (this.Padding < 0 ) {
					pos += this.Padding *-1
				}
				return Pos
			}

			hPos(){
				pos := this.parent.Height - this.Size
				if (this.Padding < 0 ) {
					pos += this.Padding * 2
				}
				return pos
			}

			wPos(){
				pos := this.parent.Width - this.Size
				if (this.Padding < 0 ) {
					pos += this.Padding * 2
				}
				return pos
			}

			Render(byref G) {
				pPen := Gdip_CreatePen("0x" . this.Opacity . this.Color , this.Size)
				Gdip_DrawRectangle(G, pPen, this.xPos(), this.yPos(), this.wPos() , this.hPos())
				Gdip_DeletePen(pPen)
			}
		}
	}

	Class TxtBox extends FancyAssToolTipZ.BackBox { 
		Label := ""
		Font := 
		FontSize := 10
		FontColor := "FFFFFF"
		FontOptions := ""
		FontOpacity := "FF"
		yPos := 0
		xPos := 0
		MaxWidth := 500

		__New() {
			this.Background := new this._BackGround(this)
			this.Border := new this._Border(this)
			this.Font := new this._Font
		}

		A( Text ){
			
			this.Text := new this._Text(this , Text)
			
			
			; TextDimensions := this.StringDimensions(this.Text , this.Font , this.FontSize, , , "Center")
			; TextDimensions := StringDimensions(this.Text , this.Font , this.FontSize)
			

			this.Width  := this.TotalWidth()
			this.Height := this.TotalHeight() 
			; MsgBox % this.Width
		}

		TotalHeight() {
			TotalH := this.Text.Height + (this.Background.Padding * 2 ) + ( this.Border.Padding >= 0 ? this.Border.Padding * 2 : 0 )  + (this.Border["Size"] *2)
			Return % TotalH
		}

		TotalWidth() {
			TotalW := this.Text.Width + (this.Background.Padding * 2 ) + ( this.Border.Padding >= 0 ? this.Border.Padding * 2 : 0 ) + (this.Border["Size"] *2)
			Return % TotalW
		}

		Render(byref G) {
			; MsgBox % this.Width
			this.BackGround.Render(G)
				
			; msgbox % "0x" . this.Border.Opacity . this.Border.Color ... 
			this.Border.Render(G)

			this.Text.Render(G)
		}

		Class _Font {
			Name := "Cascadia Mono"
			Size := 10
			Color := "FFFFFF"
			Options := ""
			Opacity := "FF"

		}

		Class _Text {

			__New(byref Parent, Text) {
				this.parent := Parent
				this.String := Text

					this.Font := this.parent.Font

				TextDimensions := this.StringDimensions(this.String , this.Font.Name, this.Font.Size)
				if ( TextDimensions["Width"] > this.parent.MaxWidth) {
					TextDimensions := this.StringDimensions(this.String , this.Font.Name, this.Font.Size, this.parent.MaxWidth)
				}

				this.Width  := TextDimensions["Width"] + Round(this.Font.Size * 1.25)
				this.Height := TextDimensions["Height"] 
			}

			xPos() {
				x_pos := 0
				x_pos += this.parent.xPos
				x_pos += ( this.parent.Border.Padding >= 0 ? this.parent.Border.Padding * 1 : 0 )
				x_pos += this.parent.Background.Padding * 1 
				return x_pos
			}

			yPos() {
				y_pos := 0
				y_pos += this.parent.yPos
				y_pos += ( this.parent.Border.Padding >= 0 ? this.parent.Border.Padding * 1 : 0 )
				y_pos += this.parent.Background.Padding * 1 
				return y_pos
			}

			Render(byref G) {
				

				
				Gdip_FontFamilyCreate(this.Font)
				; msgOptions := "x" . (this.Border.Width) ? this.Border.Width : 0 .  " y" . (this.Border.Width) ? this.Border.Width : 0  . " w100p Centre c" . this.FontOpacity . this.FontColor . " r4 s" . this.FontSize . ""
				msgOptions := "x" . ( this.xPos() ) . " y" . ( this.yPos() ) . " w100p h100p Center c" . (this.Font.Opacity . this.Font.Color) . " r4 s" . this.Font.Size . ""
				Gdip_TextToGraphics(G, "" . this.String . "", msgOptions, this.Font.Name, this.Width, this.Height , , , 3)
			}

			StringDimensions( String , Font := "Arial" , FontSize := 10 , Width := "" , Options := "" ) {
				/* ***** StringDimensions *****
					@@@ Description:Get the length and height of a string in a particular font with a particular font size. Idk... 
					@@@				it's useful to me. So I adapted it ironically to size another gui window. If you aren't me and
					@@@				you are using this I apologize in advance. I hope you aren't reading this for help with the 
					@@@				options and I wish you the best!
					
					@@@ Version: 		1.0
					@@@ Author:			W3ap0n-X 
					@@@	Special Thanks:	In case I ever post this in something public FanaticGuru I love you see the link below
					@@@						https://www.autohotkey.com/boards/viewtopic.php?p=67682#p67682

					@@@ Arguments
						>>> $String		string 	of text to measure
						>>> $Font		string 	representing a font name
						>>> $Fontsize	int 	it's the font size
						>>> $Width		int		If you want to limit the width of the text to fit in a certain width
						>>> $Options	string	preformatted options string 
												+++ This is where Bold and Italic etc go
												??? I'm going to go ahead and trunst myself and assume that the options are valid 
												!!! Just make sure that they are
					@@@ Returns
						>>> $StringDimensionsInfo 	array	Key/Val array containing $Width and $Height in px of result
					
				*/
				TxtOptions := ( !Width ? "R1" : "w" . Width ) 
				Gui, StringDimensions:New, -DPIScale
				Gui, StringDimensions:Margin, 0, 0
				Gui, StringDimensions:Font, % "s" . FontSize . ( !Options ? "": " " . Options) , % Font
				Gui, StringDimensions:Add, Text, % TxtOptions, %String%
				GuiControlGet, TextPos, StringDimensions:Pos, Static1
				Gui, StringDimensions:Destroy
				StringDimensionsInfo := { "Width" : TextPosW , "Height" : TextPosH }
				return StringDimensionsInfo
			}
		}

	}

}
