package it.pixeldump.utils {

    /**
     * Utility methods for working with color uints.
     *
     * @author Chris Callendar
 	 * @source URL http://flexdevtips.blogspot.it/
     */
    public final class ColorUtil2 {

        private static const FACTOR:Number = 0.7;

        /**
         * Returns a color value with the given red, green, blue, and alpha
         * components
         * @param r the red component (0-255)
         * @param g the green component (0-255)
         * @param b the blue component (0-255)
         * @param a the alpha component (0-255, 255 by default)
         * @return the color value
         *
         */
        public static function rgba(r:uint, g:uint, b:uint, a:uint = 255):uint {
            return ((a & 0xFF) << 24) | ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF);
        }

        /**
         * Returns a color value by updating the alpha component of another color value.
         * @param c a color value
         * @param a the desired alpha component (0-255)
         * @return a color value with adjusted alpha component
         */
        public static function setAlpha(c:uint, a:uint):uint {
            return ((a & 0xFF) << 24) | (c & 0x00FFFFFF);
        }

        /**
         * Returns the alpha component of a color value
         * @param c the color value
         * @return the alpha component
         */
        public static function getAlpha(c:uint):uint {
            return (c >> 24) & 0xFF;
        }


        public static function getRed(rgb:uint):uint {
            return ((rgb >> 16) & 0xFF);
        }

        public static function getGreen(rgb:uint):uint {
            return ((rgb >> 8) & 0xFF);
        }

        public static function getBlue(rgb:uint):uint {
            return (rgb & 0xFF);
        }

        /**
         * Combines the red, green, and blue color components into one 24 bit uint.
         */
        public static function combine(r:uint, g:uint, b:uint):uint {
            return (Math.min(Math.max(0, r), 255) << 16) | (Math.min(Math.max(0, g), 255) << 8) | Math.min(Math.max(0, b), 255);
        }

        /**
         * Combines the color value and the alpha value into a 32 bit uint like #AARRGGBB.
         */
        public static function combineColorAndAlpha(color:uint, alpha:Number):uint {
            // make sure the alpha is a valid number [0-1]
            if (isNaN(alpha)) {
                alpha = 1;
            } else {
                alpha = Math.max(0, Math.min(1, alpha));
            }

            // convert the [0-1] alpha value into [0-255]
            var alphaColor:uint = alpha * 255;
            // bitshift it to come before the color
            alphaColor = alphaColor << 24;
            // combine the two values: #AARRGGBB
            var combined:uint = alphaColor | color;
            return combined;
        }

        /**
         * Returns the average of the two colors.  Doesn't look at alpha values. */
        public static function average(c1:uint, c2:uint):uint {
            var r:uint = (getRed(c1) + getRed(c2)) / 2;
            var g:uint = (getGreen(c1) + getGreen(c2)) / 2;
            var b:uint = (getBlue(c1) + getBlue(c2)) / 2;
            return combine(r, g, b);
        }

        // copied from java
        public static function brighter(rgb:uint):uint {
            var r:uint = getRed(rgb);
            var g:uint = getGreen(rgb);
            var b:uint = getBlue(rgb);
            var factor:Number = 0.7;
            /*
            * 1. black.brighter() should return grey
            * 2. applying brighter to blue will always return blue, brighter
            * 3. non pure color (non zero rgb) will eventually return white
            */
            var i:int = int(1.0 / (1.0 - FACTOR));
            if (r == 0 && g == 0 && b == 0) {
                return combine(i, i, i);
            }
            if (r > 0 && r < i) {
                r = i;
            }
            if (g > 0 && g < i) {
                g = i;
            }
            if (b > 0 && b < i) {
                b = i;
            }
            var newRGB:uint = combine(uint(r / FACTOR), uint(g / FACTOR), uint(b / FACTOR));
            return newRGB;
        }

        // copied from Java
        public static function darker(rgb:uint):uint {
            var r:uint = getRed(rgb) * FACTOR;
            var g:uint = getGreen(rgb) * FACTOR;
            var b:uint = getBlue(rgb) * FACTOR;
            var newRGB:uint = combine(r, g, b);
            return newRGB;
        }

        public static function invert(rgb:uint):uint {
            var r:uint = getRed(rgb);
            var g:uint = getGreen(rgb);
            var b:uint = getBlue(rgb);
            var newRGB:uint = combine(255 - r, 255 - g, 255 - b);
            return newRGB;
        }

        /**
         * See mx.utils.ColorUtil.adjustBrightness2
         */
        public static function brightness(rgb:uint, brite:Number):uint {
            return adjustBrightness2(rgb, brite);
        }

        /**
         * Returns either black or white depending on the bgColor to ensure
         * that the text will contrast on the background color.
         */
        public static function getTextColor(bgColor:uint):uint {
            var textColor:uint = 0; // black
            var r:uint = getRed(bgColor);
            var g:uint = getGreen(bgColor);
            var b:uint = getBlue(bgColor);
            var rgb:uint = r + g + b;
            if (rgb < 400) {
                textColor = 0xffffff; // white
            }
            return textColor;
        }

        public static function toHex(rgb:uint):String {
            return "#" + rgb.toString(16);
        }

        public static function toRGB(rgb:uint):String {
            return getRed(rgb) + "," + getGreen(rgb) + "," + getBlue(rgb);
        }

		/**
		 * return uint in form 0xFFFFFFFF or #FFFFFFFF as string
		 */
		public static function uint2hex(c:uint, t:Boolean = true):String {

			var hs:String="";
			var zero:String="0";

			var a:String = ((c >> 24) & 0xFF).toString(16).toUpperCase();
			var r:String = ((c >> 16) & 0xFF).toString(16).toUpperCase();
			var g:String =((c >> 8) & 0xFF).toString(16).toUpperCase();
			var b:String =(c & 0xFF).toString(16).toUpperCase();


			if(a.length == 1) a = zero.concat(r);
			if(r.length == 1) r = zero.concat(r);
			if(g.length == 1) g = zero.concat(g);
			if(b.length == 1) b = zero.concat(b);

			if(t) hs = "0x" +a +r +g +b;
			else hs = "#" +a +r +g +b;

			return hs;
		}

		/*
		public static function uint2hex(dec:uint):String {

			// http://blog.rcq129.com/coding/as3-uint-to-hex/

			var digits:String = "0123456789ABCDEF";
			var hex:String = '';

			while (dec > 0) {

				var next:uint = dec & 0xF;
				dec >>= 4;
				hex = digits.charAt(next) + hex;
			}

			if (hex.length == 0) hex = '0';

			return hex;
		}
		*/


		/**
		 *  Performs a linear brightness adjustment of an RGB color.
		 *
		 *  <p>The same amount is added to the red, green, and blue channels
		 *  of an RGB color.
		 *  Each color channel is limited to the range 0 through 255.</p>
		 *
		 *  @param rgb Original RGB color.
		 *
		 *  @param brite Amount to be added to each color channel.
		 *  The range for this parameter is -255 to 255;
		 *  -255 produces black while 255 produces white.
		 *  If this parameter is 0, the RGB color returned
		 *  is the same as the original color.
		 *
		 *  @return New RGB color.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function adjustBrightness(rgb:uint, brite:Number):uint {
			var r:Number = Math.max(Math.min(((rgb >> 16) & 0xFF) + brite, 255), 0);
			var g:Number = Math.max(Math.min(((rgb >> 8) & 0xFF) + brite, 255), 0);
			var b:Number = Math.max(Math.min((rgb & 0xFF) + brite, 255), 0);

			return (r << 16) | (g << 8) | b;
		}

		/**
		 *  Performs a scaled brightness adjustment of an RGB color.
		 *
		 *  @param rgb Original RGB color.
		 *
		 *  @param brite The percentage to brighten or darken the original color.
		 *  If positive, the original color is brightened toward white
		 *  by this percentage. If negative, it is darkened toward black
		 *  by this percentage.
		 *  The range for this parameter is -100 to 100;
		 *  -100 produces black while 100 produces white.
		 *  If this parameter is 0, the RGB color returned
		 *  is the same as the original color.
		 *
		 *  @return New RGB color.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function adjustBrightness2(rgb:uint, brite:Number):uint {
			var r:Number;
			var g:Number;
			var b:Number;

			if (brite == 0)
				return rgb;

			if (brite < 0) {
				brite = (100 + brite) / 100;
				r = ((rgb >> 16) & 0xFF) * brite;
				g = ((rgb >> 8) & 0xFF) * brite;
				b = (rgb & 0xFF) * brite;
			} else // bright > 0
			{
				brite /= 100;
				r = ((rgb >> 16) & 0xFF);
				g = ((rgb >> 8) & 0xFF);
				b = (rgb & 0xFF);

				r += ((0xFF - r) * brite);
				g += ((0xFF - g) * brite);
				b += ((0xFF - b) * brite);

				r = Math.min(r, 255);
				g = Math.min(g, 255);
				b = Math.min(b, 255);
			}

			return (r << 16) | (g << 8) | b;
		}

		/**
		 *  Performs an RGB multiplication of two RGB colors.
		 *
		 *  <p>This always results in a darker number than either
		 *  original color unless one of them is white,
		 *  in which case the other color is returned.</p>
		 *
		 *  @param rgb1 First RGB color.
		 *
		 *  @param rgb2 Second RGB color.
		 *
		 *  @return RGB multiplication of the two colors.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function rgbMultiply(rgb1:uint, rgb2:uint):uint {
			var r1:Number = (rgb1 >> 16) & 0xFF;
			var g1:Number = (rgb1 >> 8) & 0xFF;
			var b1:Number = rgb1 & 0xFF;

			var r2:Number = (rgb2 >> 16) & 0xFF;
			var g2:Number = (rgb2 >> 8) & 0xFF;
			var b2:Number = rgb2 & 0xFF;

			return ((r1 * r2 / 255) << 16) | ((g1 * g2 / 255) << 8) | (b1 * b2 / 255);
		}
    }
}
