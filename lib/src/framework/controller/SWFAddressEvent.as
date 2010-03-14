/*
 * SWFAddress 2.3: Deep linking for Flash and Ajax <http://www.asual.com/swfaddress/>
 *
 * SWFAddress is (c) 2006-2009 Rostislav Hristov and contributors
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 * 
 * @author Rostislav Hristov <http://www.asual.com>
 * @author Matthew J Tretter <http://www.exanimo.com>
 * @author Piotr Zema <http://felixz.mark-naegeli.com>
 */
package framework.controller {

    import flash.events.Event;
    
    /**
     * Event class for SWFAddress.
     */
    public class SWFAddressEvent extends Event {
        
        /**
         * Init event.
         */
        public static const INIT:String = 'init';

        /**
         * Change event.
         */
        public static const CHANGE:String = 'change';
        
        private var _value:String;
        private var _path:String;
        private var _pathNames:Array;
        private var _parameterNames:Array;
        private var _parameters:Object;
        
        /**
         * Creates a new SWFAddress event.
         * @param type Type of the event.
         * @constructor
         */
        public function SWFAddressEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
        }

        /**
         * The current target of this event.
         */
        public override function get currentTarget():Object {
            return SWFAddress;
        }

        /**
         * The target of this event.
         */
        public override function get type():String {
            return super.type;
        }

        /**
         * The target of this event.
         */
        public override function get target():Object {
            return SWFAddress;
        }

        /**
         * The value of this event.
         */
        public function get value():String {
            if (_value == null) {
                _value = SWFAddress.getValue();
            }
            return _value;
        }

        /**
         * The path of this event.
         */
        public function get path():String {
            if (_path == null) {
                _path = SWFAddress.getPath();
            }
            return _path;
        }
        
        /**
         * The folders in the deep linking path of this event.
         */
         /*
        public function get pathNames():Array {
            if (_pathNames == null) {
                _pathNames = SWFAddress.getPathNames();
            }
            return _pathNames;
        }*/
        
        /**
         * The parameters of this event.
         *//*
        public function get parameters():Object {
            if (_parameters == null) {
                _parameters = new Object();
                for (var i:int = 0; i < parameterNames.length; i++) {
                    _parameters[parameterNames[i]] = SWFAddress.getParameter(parameterNames[i]);
                }
            }
            return _parameters;
        }*/
        
        /**
         * The parameters names of this event.
         *//*
        public function get parameterNames():Array {
            if (_parameterNames == null) {
                _parameterNames = SWFAddress.getParameterNames();            
            }
            return _parameterNames;
        }*/
    
        /**
         * Clones this event.
         */
        public override function clone():Event {
            return new SWFAddressEvent(type, bubbles, cancelable);
        }
    
        /**
         * The string representation of the object.
         */
        public override function toString():String {
            return formatToString('SWFAddressEvent', 'type', 'bubbles', 'cancelable', 
                'eventPhase', 'value', 'path', 'pathNames', 'parameterNames', 'parameters');
        }
    }
}