package it.pixeldump.graphic.theme {

	/*[Bindable]*/
	public class Resource {

		//[Embed(source="../assets/themes/musictutor/pathresource.xml", mimeType="application/octet-stream")]
		[Embed(source="../assets/themes/p.xml", mimeType="application/octet-stream")]
		public static const PATH_RES:Class;

		//[Embed(source="../assets/themes/musictutor/graphicresource.xml", mimeType="application/octet-stream")]
		[Embed(source="../assets/themes/g.xml", mimeType="application/octet-stream")]
		public static const GRAPHIC_RES:Class;

		//public function Resource() {}
	}
}