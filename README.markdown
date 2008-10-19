# validates\_url\_format\_of

Rails plugin that provides `validates_url_format_of` to `ActiveRecord` models.

## Usage

After installing the plugin, it's used like

    class User < ActiveRecord::Base
      validates_url_format_of :url,
                              :allow_nil => true,
                              :message => 'is completely unacceptable'
    end
    
Takes the same arguments as [`validates_format_of`](http://api.rubyonrails.org/classes/ActiveRecord/Validations/ClassMethods.html#M001052) except for the `:with` regexp.

The default `:message` is different based on whether or not the attribute name contains the word "URL". So you will get "Homepage URL does not appear to be valid" but "Homepage does not appear to be a valid URL" without having to customize the `:message`.

Please note that the regexp used to validate URLs is not perfect, but hopefully good enough. See the test suite. Patches are very welcome.
  
## Credits and license

By [Henrik Nyh](http://henrik.nyh.se/) under the MIT license:

>  Copyright (c) 2008 Henrik Nyh
>
>  Permission is hereby granted, free of charge, to any person obtaining a copy
>  of this software and associated documentation files (the "Software"), to deal
>  in the Software without restriction, including without limitation the rights
>  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>  copies of the Software, and to permit persons to whom the Software is
>  furnished to do so, subject to the following conditions:
>
>  The above copyright notice and this permission notice shall be included in
>  all copies or substantial portions of the Software.
>
>  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>  THE SOFTWARE.
