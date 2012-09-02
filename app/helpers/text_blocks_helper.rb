module TextBlocksHelper
    
    STATE_ABBRS =  ["al", "ak", "az", "ar", "ca", "co", "ct", "de", "fl", "ga", "hi",
                    "id", "il", "in", "ia", "ks", "ky", "la", "me", "md", "ma", "mi",
                    "mn", "ms", "mo", "mt", "ne", "nv", "nh", "nj", "nm", "ny", "nc",
                    "nd", "oh", "ok", "or", "pa", "ri", "sc", "sd", "tn", "tx", "ut",
                    "vt", "va", "wa", "wv", "wi", "wy"]
    
    def parse_address_text(text)
        @address = Address.new
        addressee = []
        address = []
        bottom_line = ""
        
        #iterate through each line individually
        text.split("\n").each_with_index do |line, i|
            line_ary = []
            line_ary = line.split.each {|s| s.downcase}
            puts line_ary.inspect
            # if first line, just put it straight into the name1 variable
            if i == 0
                addressee[0] = line 
                next
            end
            
            #if line starts with a number, assume it's a street address
            if line_ary[0].to_i > 0 && !address[0]
                address[0] = line
                next
            end
            
            #if the line contains a state abbreviation, it's the last line.
            #this test also eliminates the possibility of an extra newline 
            #at the end of the input string, which could lead to an empty 
            #last array element.
            if contains_state_abbr?(line_ary)
                bottom_line = line
                break
            end
            
            
        end
    end
    
    def contains_state_abbr?(line_ary)
        #because it's checking the array and not the string, "ms. smith"
        #won't trip the function up
        STATE_ABBRS.each do |s|
            if line_ary.include?(s)
                return true
            end
        end
        
        return false
    end
    
end
