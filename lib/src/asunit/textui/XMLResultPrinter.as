package asunit.textui {

    import asunit.errors.AssertionFailedError;
    import asunit.framework.Test;
    import asunit.framework.TestListener;
    import asunit.framework.TestResult;
	import flash.text.*;
	import flash.events.*;
    import flash.utils.setTimeout;
    import flash.utils.Dictionary;
    
    /**
    *   The <code>XMLResultPrinter</code> is used to transform AsUnit test results
    *   to JUnit-compatible XML content.
    *   
    *   This printer will send JUnit-compatible XML content to trace output. The XML content
    *   will be enclosed by '&lt;XMLResultPrinter/&gt;' tags.
    *   
    *   @includeExample XMLResultPrinterExample.as
    *   @includeExample XMLResultPrinterExample.xml
    **/
    public class XMLResultPrinter extends ResultPrinter {
        
        protected var results:Dictionary;

        public function XMLResultPrinter() {
            results = new Dictionary();
        }

        override public function startTest(test:Test):void {
            super.startTest(test);
            var result:TestListener = new XMLTestResult(test);
            results[test.getName()] = result;
            result.startTest(test);
        }

        override public function endTest(test:Test):void {
            super.endTest(test);
            results[test.getName()].endTest(test);
        }
        
        override public function startTestMethod(test:Test, methodName:String):void {
            super.startTestMethod(test, methodName);
            results[test.getName()].startTestMethod(test, methodName);
        }

        override public function endTestMethod(test:Test, methodName:String):void {
            super.endTestMethod(test, methodName);
            results[test.getName()].endTestMethod(test, methodName);
        }

        override public function addFailure(test:Test, t:AssertionFailedError):void {
            super.addFailure(test, t);
            results[test.getName()].addFailure(test, t);
        }
        
        override public function addError(test:Test, t:Error):void {
            super.addError(test, t);
            results[test.getName()].addError(test, t);
        }

        override public function printResult(result:TestResult, runTime:Number):void {
			var tf:TextField = new TextField();
			tf.autoSize = "left";
			tf.width = stage.stageWidth;
			if( result.errorCount() == 0 && result.failureCount() == 0 ){
				graphics.beginFill(0x00FF00,0.85);
				tf.htmlText = "<font face='Arial' color='#FFFFFF'>Everything is OKAY: " + result.runCount() + " test run in " + elapsedTimeAsString(runTime) + " seconds."
			}else{
				graphics.beginFill(0xFF0000,0.85);
				tf.htmlText = "<font face='Arial' color='#FFFFFF'>TEST FAILED: "+ result.errorCount() +" Errors, "+ result.failureCount() +" Failures, " + result.runCount() + " test run in "+ elapsedTimeAsString(runTime)  + " seconds. Click to see more info."
			}
			graphics.drawRect(0,0,stage.stageWidth,tf.height);
			addChild(tf);
			mouseChildren = false;
			var isOpen:Boolean = false;
			addEventListener(MouseEvent.CLICK, function(ev:Event):void{
				if( isOpen || result.errorCount() == 0 && result.failureCount() == 0 ){
					graphics.clear();
					removeChild(tf);
				}else{
					isOpen = true;
					var txt:String = "Click again to close this window:\n";
					for each( var testResult:* in results) {
		                txt += testResult.toString();
		            }
					tf.text = txt;
					graphics.clear();
					graphics.beginFill(0xFF0000,0.5);
					graphics.drawRect(0,0,stage.stageWidth,tf.height);
				}
			})
        }
    }
}

import asunit.framework.Test;
import asunit.framework.TestFailure;
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer;
import asunit.framework.TestListener;
import asunit.errors.AssertionFailedError;
import asunit.framework.TestMethod;
import flash.utils.Dictionary;    

class XMLTestResult implements TestListener {
    
    private var _duration:Number;
    private var start:Number;
    private var test:Test;
    private var testName:String;
    private var failureHash:Dictionary;
    private var failures:Array;
    private var errorHash:Dictionary;
    private var errors:Array;
    private var methodHash:Dictionary;
    private var methods:Array;
    
    public function XMLTestResult(test:Test) {
        this.test = test;
        testName = test.getName().split("::").join(".");
        failures = new Array();
        errors = new Array();
        methods = new Array();
        
        failureHash = new Dictionary();
        errorHash = new Dictionary();
        methodHash = new Dictionary();
    }

    public function startTest(test:Test):void {
        start = getTimer();
    }
    
    public function run(test:Test):void {
    }

    public function addError(test:Test, t:Error):void {
        var failure:TestFailure = new TestFailure(test, t);
        errors.push(failure);
        errorHash[failure.failedMethod()] = failure;
    }

    public function addFailure(test:Test, t:AssertionFailedError):void {
        var failure:TestFailure = new TestFailure(test, t);
        failures.push(failure);
        failureHash[failure.failedMethod()] = failure;
    }

    public function startTestMethod(test:Test, methodName:String):void {
        var method:TestMethod = new TestMethod(test, methodName);
        methods.push(method);
        methodHash[method.getName()] = method;
    }

    public function endTestMethod(test:Test, methodName:String):void {
        methodHash[methodName].endTest(test);
    }

    public function endTest(test:Test):void {
        _duration = (getTimer() - start) * .001;
    }
    
    private function errorCount():int {
        return errors.length;
    }
    
    private function failureCount():int {
        return failures.length;
    }
    
    private function duration():Number {
        return _duration;
    }
    
    private function renderSuiteOpener():String {
        return "";//"<testsuite name='" + testName + "' errors='" + errorCount() + "' failures='" + failureCount() + "' tests='" + methods.length + "' time='" + duration() + "'>\n";
    }
    
    private function renderTestOpener(methodName:String):String {
        return "";//"<testcase classname='" + testName + "' name='" + methodName + "' time='" + methodHash[methodName].duration() + "'>\n";
    }
    
    private function renderTestBody(method:String):String {
        if(errorHash[method]) {
            return renderError(errorHash[method]);
        }
        else if(failureHash[method]) {
            return renderFailure(failureHash[method]);
        }
        else {
            return "";
        }
    }
    
    private function renderError(failure:TestFailure):String {
        return getQualifiedClassName(failure.thrownException()).split("::").join(".")+"\n"+failure.thrownException().getStackTrace()+"\n";//"<error type='" + getQualifiedClassName(failure.thrownException()).split("::").join(".") + "'><![CDATA[\n" + failure.thrownException().getStackTrace() + "\n]]></error>\n";
    }
    
    private function renderFailure(failure:TestFailure):String {
        return getQualifiedClassName(failure.thrownException()).split("::").join(".")+"\n"+failure.thrownException().getStackTrace()+"\n";//"<failure type='" + getQualifiedClassName(failure.thrownException()).split("::").join(".") + "'><![CDATA[\n" + failure.thrownException().getStackTrace() + "\n]]></failure>\n";
    }
    
    private function renderTestCloser():String {
        return "";//'</testcase>\n';
    }
    
    private function renderSuiteCloser():String {
        return "";//'</testsuite>\n';
    }
    
    public function toString():String {
        var str:String = '';
        str += renderSuiteOpener();
        for(var name:String in methodHash) {
            str += renderTestOpener(name);
            str += renderTestBody(name);
            str += renderTestCloser();
        }
        str += renderSuiteCloser();
        return str;
    }
}

