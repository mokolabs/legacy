class TextHelper
  class << self
    def update_slug(name)
      slug = name.to_s.dup
      slug.gsub!(/'/,'') # remove characters that occur mid-word
      slug.gsub!(/[\W]/,' ') # translate non-words into spaces
      slug.strip! # remove spaces from the ends
      slug.gsub!(/\ +/,'-') # replace spaces with hyphens
      slug.downcase # lowercase what's left
    end

    def migrate(text)
      text = condense_whitespace(text)
      text = remove_leading_spaces(text)

      text = remap_windows_characters(text)
      text = simplify_smart_characters(text)
      
      text = update_cinema_treasures_links(text)
      text = update_model_links(text)
      text = update_theater_links(text)
      
      text = remove_image_attributes(text)
      text = force_images_into_paragraphs(text)
      
      text = convert_html_to_markdown(text)
      text = convert_pmachine_code_to_markdown(text)
    end
    
    def condense_whitespace(text)
      text = text.gsub(/[\t ]+/,' ')
    end
    
    def remove_leading_spaces(text)
      text = text.gsub(/\n[ ]+/,"\n")
      text = text.gsub(/\r[ ]+/,"\r")
      text = text.gsub(/\r\n[ ]+/,"\r\n")
    end
    
    def remap_windows_characters(text)
      # text = text.gsub "\342\200\230", "'"
      # text = text.gsub "\342\200\231", "'"
      # text = text.gsub "\342\200\234", '"'
      # text = text.gsub "\342\200\235", '"'
         
      # â€™ => ' (right single quote)
      text = text.gsub(/â€™/,'\'')

      # � => ' (right single quote)
      text = text.gsub(/�/,'\'')
           
      # â€œ => " (left double quote)
      text = text.gsub(/â€œ/,'"')
     
      # â€? => " (right double quote)
      text = text.gsub(/â€?/,'"')
  
      # â€ => " (right double quote)
      text = text.gsub(/â€/,'"')
          
      #   (line break)
      # text = text.gsub(//,"\r\n")
    end

    def simplify_smart_characters(text)
      # Single quotes
      text = text.gsub(/‘/,'\'')
      text = text.gsub(/’/,'\'')
      
      # Double quotes
      text = text.gsub(/“/,'"')
      text = text.gsub(/”/,'"')
      
      # Ellipsis
      text = text.gsub(/…/,'...')
      
      # Em dash
      text = text.gsub(/—/,'--')
      
      # Em dash
      text = text.gsub(/–/,'---')
    end
    
    def update_cinema_treasures_links(text)
      # Only use .org
      text = text.gsub(/cinematreasures\.(com|net)/i,'cinematreasures.org')

      # Pluralize Cinema Treasures
      text = text.gsub(/cinematreasure\.(com|net|org)/i,'cinematreasures.org')

      # Remove www.
      text = text.gsub(/www\.cinematreasures\.org/i,'cinematreasures.org')
    end
    
    def update_model_links(text)
      # http://cinematreasures.org/members/profile.php?id=1
      # http://cinematreasures.org/members/profile_view_ind.php?id=1
      text = text.gsub(/http:\/\/cinematreasures.org\/members\/profile\.php\?id=/,'/users/')
      text = text.gsub(/http:\/\/cinematreasures.org\/members\/profile_view_ind\.php\?id=/,'/users/')
      
      # Pluralize model links
      text = text.gsub(/\/architect\//,"/architects/")
      text = text.gsub(/\/chain\//,"/chains/")
      text = text.gsub(/\/firm\//,"/firms/")
      text = text.gsub(/\/function\//,"/functions/")
      text = text.gsub(/\/style\//,"/styles/")
    end
    
    def update_theater_links(text)
      # [url=theater/460]Des Plaines Theatre[/url]
      # [url=/theater/460/]Des Plaines Theatre[/url]
      text = text.gsub(/\[url=\/?theater\//,'[url=/theaters/')

      # [url=http://cinematreasures.org/theater/3869/]
      text = text.gsub(/\[url=http:\/\/cinematreasures.org\/theater\//,'[url=/theaters/')

      # http://cinematreasures.org/theater/4866/
      # this will convert links in this form: [url=link]link[/url]
      text = text.gsub(/http:\/\/cinematreasures.org\/theater\//,'http://cinematreasures.org/theaters/')
    end

    def convert_html_to_markdown(text)
      # Before: <a href="http://google.com">Google</a>
      # After: [Google](http://google.com)
      text = text.gsub(/(<a href=")(.*?)(">)(.*?)(<\/a>)/, ('[\4](\2)'))

      # <strong> and <b>
      text = text.gsub(/<strong>|<\/strong>|<b>|<\/b>/, ('**'))
      
      # <em> and <i>
      text = text.gsub(/<em>|<\/em>|<i>|<\/i>/, ('*'))
    end
    
    def convert_pmachine_code_to_markdown(text)
      # Remove target attributes on links
      text = text.gsub(/ target="_blank"/,'')
      text = text.gsub(/ target="_self"/,'')
      text = text.gsub(/ target="_self/,'')
      
      # Lowercase all pM tags
      text = text.gsub(/(\[|\[\/)(URL)/,'\1url')
      text = text.gsub(/(\[|\[\/)(EMAIL)/,'\email')
      text = text.gsub(/(\[|\[\/)(IMG)/,'\img')
      text = text.gsub(/(\[|\[\/)(QUOTE)/,'\quote')
      text = text.gsub(/(\[|\[\/)(I)/,'\i')
      text = text.gsub(/(\[|\[\/)(B)/,'\b')
      text = text.gsub(/(\[|\[\/)(EM)/,'\em')
      text = text.gsub(/(\[|\[\/)(STRONG)/,'\strong')
      
      # [url=http://google.com]Google[/url]
      text = text.gsub(/(\[url\=)(.*?)(\])(.*?)(\[\/url\])/, ('[\4](\2)'))
        
      # [email=patrick@mokolabs.com]email me[/email]
      text = text.gsub(/(\[email\=)(.*?)(\])(.*?)(\[\/email\])/, ('[\4](\2)'))
    
      # [email]patrick@mokolabs.com[/email]
      text = text.gsub(/(\[email\])(.*?)(\[\/email\])/, ('\2'))

      # [img]smiley.jpg[/img]
      text = text.gsub(/(\[img\])(.*?)(\[\/img\])/, ('<img src="\2" />'))

      # [quote]Some text. blah, blah, blah...[/quote]
      text = text.gsub(/(\[quote\])(.*?)(\[\/quote\])/, ('<blockquote>\2</blockquote>'))

      # [b]some text[/b]
      text = text.gsub(/(\[b\])(.*?)(\[\/b\])/, ('**\2**'))
      
      # [strong]some text[/strong]
      text = text.gsub(/(\[strong\])(.*?)(\[\/strong\])/, ('**\2**'))

      # [i]some text[/i]
      text = text.gsub(/(\[i\])(.*?)(\[\/i\])/, ('*\2*'))
     
      # [em]some text[/em]
      text = text.gsub(/(\[em\])(.*?)(\[\/em\])/, ('*\2*'))
       
      # Other tags we don't need to worry about:
      # [size], [color], [pre], [encode]
    end
    
    def force_images_into_paragraphs(text)
      text = text.gsub(/(<img.*\/>){2,}/) { |match|
        match.gsub!(/\/><img /, "/>\n\n<img ")
      }
    end
    
    def remove_image_attributes(text)
      # Remove things we don't need
      text = text.gsub(/ alt="image"/,'')
      text = text.gsub(/ border="0"/,'')
      text = text.gsub(/ style="border-bottom: 1px solid #fff;"/,'')
      text = text.gsub(/ style="border-bottom: 1px solid #fff"/,'')
      text = text.gsub(/ style="border-bottom: 1px dotted #fff;"/,'')
    end
    
    # TODO
    # Permanent redirects for old URLs (via .htaccess)
    # Use #sanitize_cinema_treasures_links on all saves (not just migration)
    # Add missing blockquote tags to source quotes enclosed only by quote marks
    # Don't convert horizontal rules
    # Remove ‘Read More’ blocks?!
    # Deal with super long image links in comments
    # Find a better way to import European characters 
  end
end
