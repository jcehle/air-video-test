package com.allofus.shared.text 
{
	import flash.text.TextFormat;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.shared.util.DrawUtils;

	import mx.logging.ILogger;

	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;



	/**
	 * @author ehlejc
	 */
	public class FontManager 
	{
		private static const logger : ILogger = GetLogger.qualifiedName(FontManager);
		
		public static var cssStyle : StyleSheet;
		
		protected static var glowFilter : GlowFilter = new GlowFilter(0x000000, 1, 5, 5, 2.5, 2);

		public static function createGradientText(label : String, style : String, _colors : Array = null, _ratios : Array = null, multi : Boolean = false) : Sprite
		{
			var colors : Array = (_colors) ? _colors : [0xFFFFFF, 0x000000];
			var ratios : Array = (_ratios) ? _ratios : [0, 255];
			var holder : Sprite = new Sprite();
			var txt : TextField = createStyledTextField(label, style, multi);
			txt.name = "label";
			holder.addChild(txt);
			var gradientTxt : Sprite = DrawUtils.drawGradientBox(GradientType.LINEAR, txt.width, txt.height, colors, [1, 1], ratios, 90);
			holder.addChild(gradientTxt);
			gradientTxt.mask = txt;
			return holder;
		}
		
		public static function createTextField(str : String, width:int = 400, height:int = 0, multiline:Boolean = false, justify:String = null) : TextField
		{
			var field : TextField = new TextField();
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.gridFitType = GridFitType.NONE;
			
			
			if (width && height)
			{
				field.width = width;
				field.height = height;
			}
			else
			{
				field.autoSize = TextFieldAutoSize.LEFT;
			}
			
			field.multiline = multiline;
			field.wordWrap = multiline;
			if(multiline)
			{
				field.autoSize = TextFieldAutoSize.LEFT;
			}
			
			if(justify)
			{
				var fmt:TextFormat = field.getTextFormat();
				fmt.align = justify;
			}
			field.width = width;
			field.height = height;
			
			field.styleSheet = cssStyle;
			field.embedFonts = true;
//			field.border = true;
			field.selectable = false;
			field.htmlText = str;
			return field;
		}

		public static function createStyledTextField(label : String, style : String = "copy", multi : Boolean = false, width:Number = 400, height:Number = 10, selectable:Boolean = false) : TextField
		{
			var field : TextField = new TextField();
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.gridFitType = GridFitType.NONE;
			field.autoSize = TextFieldAutoSize.LEFT;
			
			field.multiline = multi;
			field.wordWrap = multi;
			
			if (width && height)
			{
				field.width = width;
				field.height = height;
			}
			else
			{
				field.autoSize = TextFieldAutoSize.LEFT;
			}
			
			
			field.styleSheet = cssStyle;
			field.embedFonts = true;
//			field.border = true;
			field.selectable = selectable;
			field.htmlText = "<p class='" + style + "'>" + label + "</p>";
			return field;	
		}
		
		public static function setStyledText(textField:TextField, label:String, multi:Boolean = false, selectable:Boolean = false, autoSize:String=null) : void
		{
			textField.antiAliasType = AntiAliasType.ADVANCED;
			//textField.gridFitType = GridFitType.SUBPIXEL;
			if(autoSize)
			{
				textField.autoSize = autoSize;
			}
			textField.styleSheet = cssStyle;
			textField.embedFonts = true;
			textField.selectable = selectable;
			textField.multiline = multi;
			textField.wordWrap = multi;
			textField.htmlText = label;
		}
		
		public static function createCenterTextField(label : String, style : String = "copy", multi : Boolean = false, width:Number = 0, height:Number = 0) : TextField
		{			
			var field : TextField = new TextField();
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.gridFitType = GridFitType.NONE;
			field.autoSize = TextFieldAutoSize.CENTER;
			field.styleSheet = cssStyle || getDefaultCss();
			field.embedFonts = true;
			field.selectable = false;
			//field.border = true;
			//field.thickness = -50;
			
			
			//field.background = true;
			field.multiline = multi;
			field.wordWrap = multi;

			if (width && height)
			{
				field.width = width;
				field.height = height;
			}
			if(getStyle(style, "shadow") == "true") field.filters = [glowFilter];
			
			field.htmlText = "<p class='" + style + "'>" + label + "</p>";
			return field;
		}		
		
		public static function setText(label : TextField, text:String, style:String = "copy") : void
		{				
			label.htmlText = "<p class='" + style + "'>" + text + "</p>";
		}
		
		public static function setStyle(label : TextField, style : String) : void
		{
			var txt : String = label.text;
			logger.debug("set this text: " + txt + " to the style: " + style);
			FontManager.listStyles(); 
			label.htmlText = '';
			label.htmlText = "<span class='" + style + "'>" + txt + "</span>";
		}

		public static function getStyle( name : String, prop : String ) : *
		{
			var style : Object = cssStyle.getStyle("." + name);
			var sProp : * = style[prop];
			if(sProp != undefined ){
				// Probably a color so cast as Number
				if(sProp.charAt(0) == "#" && sProp.length == 7){
					sProp = getColorValue(sProp);
				}
				return sProp;
			}
			return null;
		}
		
		public static function getColorValue( ColorCode:String ):Number
		{
			return Number( "0x" + ColorCode.substring( 1 ) );
		}

		public static function set css(value : StyleSheet) : void 
		{
			cssStyle = value;
			listStyles();
		}
		
		public static function get styleSheet():StyleSheet
		{
			return cssStyle;
		}

		public static function listFonts():void
		{
			var fonts:Array = Font.enumerateFonts();
			for (var i:uint = 0; i < fonts.length; i++)
			{
				logger.debug("fonts registered: " + fonts[i]["fontName"] + ", " + fonts[i]["fontStyle"] + ", " + fonts[i]["fontType"]);
			}
		}
				
		public static function listStyles():void
		{
			logger.info("*Styles Registered: " + cssStyle.styleNames.length);
			if (cssStyle == null)
			{
				logger.warn("NO styles registered with FontManater.");
				return;
			}
			for (var i:uint = 0; i < cssStyle.styleNames.length; i++)
			{
				logger.debug("style: " + cssStyle.styleNames[i]);
			}
		}
		
		private  static function getDefaultCss():StyleSheet
		{
			var styleSheet:StyleSheet = new StyleSheet();
			
			var copy:Object = new Object();
			copy.fontSize = 10;
			copy.color = "#FFFFFF";
			
			styleSheet.setStyle(".copy", copy);
			
			return styleSheet;
		}

	}
}
