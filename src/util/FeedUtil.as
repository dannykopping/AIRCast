package util
{
	import com.adobe.xml.syndication.generic.RSS20Item;
	import com.adobe.xml.syndication.rss.Channel20;
	import com.adobe.xml.syndication.rss.Item20;
	import com.adobe.xml.syndication.rss.RSS20;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import mx.utils.ObjectUtil;
	
	import org.osflash.signals.Signal;
	
	import vo.EpisodeMediaVO;
	import vo.EpisodeVO;
	import vo.SubscriptionVO;

	public class FeedUtil
	{
		private static var _instance:FeedUtil;
		
		public var feedFetched:Signal;
		
		{
			_instance = new FeedUtil();
		}
		
		public function FeedUtil()
		{
			if(_instance)
				throw new Error("This class is a Singleton and cannot be instatiated more than once");
			
			feedFetched = new Signal(SubscriptionVO);
		}
		
		public static function get instance():FeedUtil
		{
			return _instance;
		}
		
		public function fetchFeed(url:String):void
		{
			var feedLoader:URLLoader = new URLLoader();
			feedLoader.addEventListener(IOErrorEvent.IO_ERROR, fetchFeedErrorHandler, false, 0, true);
			feedLoader.addEventListener(Event.COMPLETE, fetchFeedCompleteHandler, false, 0, true);
			
			feedLoader.dataFormat = URLLoaderDataFormat.TEXT;
			
			feedLoader.load(new URLRequest(url));
		}
		
		private function fetchFeedErrorHandler(event:IOErrorEvent):void
		{
			
		}
		
		private function fetchFeedCompleteHandler(event:Event):void
		{
			var rssParser:RSS20 = new RSS20();
			rssParser.parse(event.currentTarget.data.toString());
			
			var subscription:SubscriptionVO = new SubscriptionVO();
			subscription.title = rssParser.channel.title;
			subscription.description = rssParser.channel.description;
			subscription.url = rssParser.channel.link;
			
			var items:Array = rssParser.items;
			var episodes:Array = [];
			
			for each(var item:Item20 in items)
			{
				var episode:EpisodeVO = new EpisodeVO();
				episode.title = item.title;
				episode.description = item.description;
				episode.infoURL = item.link;
				
				if(!item.enclosure)
					continue;
				
				var media:EpisodeMediaVO = new EpisodeMediaVO();
				media.type = item.enclosure.type;
				media.length = item.enclosure.length;
				media.url = item.enclosure.url;
				
				episode.media = media;
				
				episode.releaseDate = item.pubDate;
				
				episodes.push(episode);
			}
			
			subscription.episodes = episodes;
			
			this.feedFetched.dispatch(subscription);
		}
	}
}