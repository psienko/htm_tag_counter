class RemotePage
    include ActiveModel::Model

    attr_accessor :url, :html_document, :tags
    validates :url, format: URI::regexp(%w(http https))
    
    TAG_DICTIONARY = [
        'a', 'abbr', 'acronym', 'address', 'applet','area','b','base','basefont',
        'bdo','bgsound','big','blockquote','blink','body','br','button','center',
        'cite','code','col','colgroup','dd','dfn','del','dir','dl','div','dt','embed',
        'em','fieldset','font','form','frame','frameset','h1','h2','h3',
        'h4','h5','h6','head','hr','html','iframe','img','input','ins','isindex',
        'i','kbd','label','legend','li','link','marquee','menu','meta','noframe',
        'noscript','optgroup','option','ol','p','pre','q','s','samp','script',
        'select','small','span','strike','strong','style','sub','sup',
        'table','td','th','tr','tbody','textarea','tfoot','thead','title',
        'tt','u','ul','var']

    def initialize(url=nil, html_document=nil, tags=nil)
        @url, @html_document, @tags = url, html_document, tags 
    end

    def html_tags
        return [] if self.html_document.blank?
       tags = TAG_DICTIONARY.map do|tag| 
            {
                name: "#{tag}",
                count: html_document.css(tag).count
            }
        end.sort_by{ |tag| tag[:count] }.reverse.map do |tag| 
            [tag[:name], tag[:count]] if tag[:count] > 0
        end - [nil]
    end


end
