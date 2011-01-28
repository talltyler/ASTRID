package {
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import asunit.framework.TestSuite;
	import com.paperlesspost.create.AppTest;
	import com.paperlesspost.create.context.AppContextTest;
	import com.paperlesspost.create.data.ContentTest;
	import com.paperlesspost.create.data.ProductsTest;
	import com.paperlesspost.create.renderers.CardTest;
	import com.paperlesspost.create.renderers.EditorTest;
	import com.paperlesspost.create.renderers.EnvelopeTest;
	import framework.cache.CacheTest;
	import framework.cache.PoolTest;
	import framework.components.ButtonTest;
	import framework.components.CheckBoxTest;
	import framework.components.ColorPickerTest;
	import framework.components.DatePickerTest;
	import framework.components.FileUploadTest;
	import framework.components.RadioButtonTest;
	import framework.components.ScrollBarTest;
	import framework.components.ScrollTest;
	import framework.components.SelectMenuTest;
	import framework.components.SliderTest;
	import framework.components.StepperTest;
	import framework.components.TextAreaTest;
	import framework.components.TextInputTest;
	import framework.config.BootTest;
	import framework.controller.ContextBaseTest;
	import framework.controller.ControllerTest;
	import framework.controller.RoutesTest;
	import framework.data.adapters.AdapterBaseTest;
	import framework.data.adapters.AMFAdapterTest;
	import framework.data.adapters.CSVAdapterTest;
	import framework.data.adapters.JSONAdapterTest;
	import framework.data.adapters.SharedObjectAdapterTest;
	import framework.data.adapters.SQLiteAdapterTest;
	import framework.data.adapters.XMLAdapterTest;
	import framework.data.DataTest;
	import framework.data.ModelBaseTest;
	import framework.data.ModelUtilsTest;
	import framework.data.UndoRedoTest;
	import framework.display.BaseTest;
	import framework.display.ElementBaseTest;
	import framework.display.TextTest;
	import framework.eval.ObjectsTest;
	import framework.events.ControllerEventTest;
	import framework.events.ListenerManagerTest;
	import framework.events.ModelEventTest;
	import framework.events.ViewEventTest;
	import framework.helpers.PaginatorTest;
	import framework.net.AssetsGroupTest;
	import framework.net.AssetsTest;
	import framework.net.AssetTest;
	import framework.net.JobTest;
	import framework.net.URITest;
	import framework.utils.ArrayPlusTest;
	import framework.utils.ArrayUtilsTest;
	import framework.utils.ClassUtilsTest;
	import framework.utils.ExternalUtilsTest;
	import framework.utils.ObjectUtilsTest;
	import framework.utils.StringUtilsTest;
	import framework.utils.TypeUtilsTest;
	import framework.utils.ValidateTest;
	import framework.view.RendererBaseTest;
	import framework.view.TextRendererTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new com.paperlesspost.create.AppTest());
			addTest(new com.paperlesspost.create.context.AppContextTest());
			addTest(new com.paperlesspost.create.data.ContentTest());
			addTest(new com.paperlesspost.create.data.ProductsTest());
			addTest(new com.paperlesspost.create.renderers.CardTest());
			addTest(new com.paperlesspost.create.renderers.EditorTest());
			addTest(new com.paperlesspost.create.renderers.EnvelopeTest());
			addTest(new framework.cache.CacheTest());
			addTest(new framework.cache.PoolTest());
			addTest(new framework.components.ButtonTest());
			addTest(new framework.components.CheckBoxTest());
			addTest(new framework.components.ColorPickerTest());
			addTest(new framework.components.DatePickerTest());
			addTest(new framework.components.FileUploadTest());
			addTest(new framework.components.RadioButtonTest());
			addTest(new framework.components.ScrollBarTest());
			addTest(new framework.components.ScrollTest());
			addTest(new framework.components.SelectMenuTest());
			addTest(new framework.components.SliderTest());
			addTest(new framework.components.StepperTest());
			addTest(new framework.components.TextAreaTest());
			addTest(new framework.components.TextInputTest());
			addTest(new framework.config.BootTest());
			addTest(new framework.controller.ContextBaseTest());
			addTest(new framework.controller.ControllerTest());
			addTest(new framework.controller.RoutesTest());
			addTest(new framework.data.adapters.AdapterBaseTest());
			addTest(new framework.data.adapters.AMFAdapterTest());
			addTest(new framework.data.adapters.CSVAdapterTest());
			addTest(new framework.data.adapters.JSONAdapterTest());
			addTest(new framework.data.adapters.SharedObjectAdapterTest());
			addTest(new framework.data.adapters.SQLiteAdapterTest());
			addTest(new framework.data.adapters.XMLAdapterTest());
			addTest(new framework.data.DataTest());
			addTest(new framework.data.ModelBaseTest());
			addTest(new framework.data.ModelUtilsTest());
			addTest(new framework.data.UndoRedoTest());
			addTest(new framework.display.BaseTest());
			addTest(new framework.display.ElementBaseTest());
			addTest(new framework.display.TextTest());
			addTest(new framework.eval.ObjectsTest());
			addTest(new framework.events.ControllerEventTest());
			addTest(new framework.events.ListenerManagerTest());
			addTest(new framework.events.ModelEventTest());
			addTest(new framework.events.ViewEventTest());
			addTest(new framework.helpers.PaginatorTest());
			addTest(new framework.net.AssetsGroupTest());
			addTest(new framework.net.AssetsTest());
			addTest(new framework.net.AssetTest());
			addTest(new framework.net.JobTest());
			addTest(new framework.net.URITest());
			addTest(new framework.utils.ArrayPlusTest());
			addTest(new framework.utils.ArrayUtilsTest());
			addTest(new framework.utils.ClassUtilsTest());
			addTest(new framework.utils.ExternalUtilsTest());
			addTest(new framework.utils.ObjectUtilsTest());
			addTest(new framework.utils.StringUtilsTest());
			addTest(new framework.utils.TypeUtilsTest());
			addTest(new framework.utils.ValidateTest());
			addTest(new framework.view.RendererBaseTest());
			addTest(new framework.view.TextRendererTest());
		}
	}
}
