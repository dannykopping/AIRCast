package controllers
{
	import org.osflash.signals.Signal;
	
	import vo.SubscriptionVO;

	public class SubscriptionController
	{
		private static var _instance:SubscriptionController;
		
		public var subscriptionAdded:Signal;
		
		{
			_instance = new SubscriptionController();
		}
		
		public function SubscriptionController()
		{
			if(_instance)
				throw new Error("This class is a Singleton and cannot be instatiated more than once");
			
			subscriptionAdded = new Signal(SubscriptionVO);
		}
		
		public static function get instance():SubscriptionController
		{
			return _instance;
		}
	}
}