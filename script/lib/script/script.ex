defmodule Script.Script do

  defstruct(
    script_types: [
      %{
        :type   => :outline,
        :params => [ :color, :thickness ],
        :script =>
        '''
        element.style.outline = '{0} solid {1}px';\n
        '''
      }, %{
        :type   => :badge,
        :params => [ :radius, :label ],
        :script =>
        '''
        var size = {0};
        var label = {1};
        var color = '{2}';

        var wrapper = document.createElement('div');
        var badge = document.createElement('span');
        var textnode = document.createTextNode(label);


        element.appendChild(wrapper);
        badge.appendChild(textnode);
        wrapper.appendChild(badge);

        element.style.position = 'relative';

        wrapper.style.display = '';
        wrapper.style.justifyContent = 'center';
        wrapper.style.alignItems = 'center';
        wrapper.style.minHeight = '';

        wrapper.style.position = 'absolute';
        wrapper.style.top = (-1 * size).toString(10) + 'px';
        wrapper.style.right = (-1 * size).toString(10) + 'px';

        badge.style.display = 'inline-block';
        badge.style.minWidth = '16px';
        badge.style.padding = (0.5 * size).toString(10) + 'px ' + (0.5 * size).toString(10) + 'px';
        badge.style.borderRadius = '50%';
        badge.style.fontSize = '25px';
        badge.style.textAlign = 'center';
        badge.style.background = color;
        badge.style.color = 'white';
        '''
      }
    ]
  )

end
