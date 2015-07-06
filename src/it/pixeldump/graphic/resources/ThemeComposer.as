package it.pixeldump.graphic.resources {

	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;

	import it.pixeldump.graphic.interfaces.IThemedUI;
	import it.pixeldump.graphic.ui.ResourceToolboxButton;
	import it.pixeldump.graphic.ui.RotatorResourceToolboxButton;

	public class ThemeComposer {

		private static const CLASS_PFX:String = "it.pixeldump.graphic.ui.";

		private static const ui1:RotatorResourceToolboxButton = null;
		private static const ui2:ResourceToolboxButton = null;

		//public function ThemeComposer() {}

		public static function createComponentByTheme(rawTheme:*):IThemedUI {

			var ba:ByteArray = rawTheme as ByteArray;

			ba.position = 0;

			var xmlSkin:XML = XML(ba.readUTFBytes(ba.length));
			var className:String = CLASS_PFX +xmlSkin..skin[0].@componentTarget;
			var clazz:Class = getDefinitionByName(className) as Class;
			var uiItem:IThemedUI = new clazz() as IThemedUI;

			uiItem.createFromXml(xmlSkin);

			return uiItem;
		}
	}
}