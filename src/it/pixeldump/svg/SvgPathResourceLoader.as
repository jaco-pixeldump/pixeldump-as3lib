
/**
 * @author jaco
 *
 * created on 5/7/2011 4:17:18 PM
 */

package it.pixeldump.svg {



	import flash.display.Graphics;
	import flash.display.GraphicsPath;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;


	import it.pixeldump.svg.events.SvgPathResourceLoaderEvent;
	import it.pixeldump.svg.vos.SvgPathResource;
	import it.pixeldump.utils.GZIPBytesEncoder;

	/**
	 *
	 */
	public class SvgPathResourceLoader extends SvgLoader{


		private var _svgPathResources:Vector.<SvgPathResource>;


		/**
		 * the constructor
		 */
		function SvgPathResourceLoader(){

			//super();

			ul.dataFormat = URLLoaderDataFormat.BINARY;

			_svgPathResources = new Vector.<SvgPathResource>();
		}

		// ---------------- private/protected methods

		protected override function onULComplete(evt:Event):void {

			var gbe:GZIPBytesEncoder = new GZIPBytesEncoder();
			var ba:ByteArray = gbe.uncompressToByteArray(ul.data as ByteArray);

			var spr:SvgPathResource = new SvgPathResource();
			var xData:XML = XML(ba.toString());
			spr.xml = xData;

			_svgPathResources.push(spr);

			//trace("spr ready");

			dispatchEvent(new SvgPathResourceLoaderEvent(SvgPathResourceLoaderEvent.RESOURCE_READY, spr));
		}

		// ---------------- public methods

		/**
		 *
		 */
		public function loadResource(resURL:String):void {
			loadData(resURL);
		}

		public function getSvgPathResourceByName(rn:String):SvgPathResource {

			for each(var spr:SvgPathResource in _svgPathResources)
				if(spr.resourceName == rn) return spr;

			return null;
		}
	} // end of class
} // end of pkg
