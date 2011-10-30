package vo
{
	[Bindable]
	public class EpisodeVO
	{
		public var title:String;
		public var description:String;
		public var infoURL:String;
		
		public var media:EpisodeMediaVO;
		
		public var releaseDate:Date;
		
		public function EpisodeVO()
		{
		}
	}
}