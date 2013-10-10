AutoHtml.add_filter(:youtube_with_start).with(:width => 420, :height => 315, :frameborder => 0, :wmode => nil) do |text, options|
  regex = /<a href=\"https?:\/\/(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=.*v=)([A-Za-z0-9_-]*)(\&\S+)?(\S*)/
  text.gsub(regex) do
    youtube_id = $3
    width = options[:width]
    height = options[:height]
    frameborder = options[:frameborder]
    start_time = 0
    start_time_embed = 0
    start_time_short = 0
    sub_text_embed = $4
    sub_text_short = $5
    if !sub_text_embed.blank?
      parameters = /.*[&?#]t=((\d*)m)?((\d*)s)?/
      sub_text_embed.gsub(parameters) do
        start_time_embed += 60*$2.to_i if !$2.blank?
        start_time_embed += $4.to_i if !$4.blank?
      end
    end
    if !sub_text_short.blank?
      parameters = /.*[&?#]t=((\d*)m)?((\d*)s)?/
      sub_text_short.gsub(parameters) do
        start_time_short += 60*$2.to_i if !$2.blank?
        start_time_short += $4.to_i if !$4.blank?
      end
    end
    start_time = (start_time_embed > start_time_short ? start_time_embed : start_time_short)
  	wmode = options[:wmode]
		src = "//www.youtube.com/embed/#{youtube_id}"
		src += "?wmode=#{wmode}" if wmode
		if wmode && start_time > 0
		  src += "&start=#{start_time.to_s}"
		elsif start_time > 0
		  src += "?start=#{start_time.to_s}"
		end
    %{<iframe width="#{width}" height="#{height}" src="#{src}" frameborder="#{frameborder}" allowfullscreen></iframe>}
  end
end
