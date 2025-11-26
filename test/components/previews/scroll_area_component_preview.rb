# frozen_string_literal: true

# @label Scroll Area
# @display bg_color "#ffffff"
class ScrollAreaComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic vertical scroll area with tags
  def default
    render(Shadcn::ScrollAreaComponent.new(class_name: "h-72 w-48 rounded-md border")) do
      '<div class="p-4">
        <h4 class="mb-4 text-sm font-medium leading-none">Tags</h4>
        <div class="text-sm">
          <div class="py-2">v1.2.0-beta.1</div>
          <div class="py-2">v1.2.0-beta.0</div>
          <div class="py-2">v1.1.2</div>
          <div class="py-2">v1.1.1</div>
          <div class="py-2">v1.1.0</div>
          <div class="py-2">v1.0.0</div>
          <div class="py-2">v0.9.0</div>
          <div class="py-2">v0.8.0</div>
          <div class="py-2">v0.7.0</div>
          <div class="py-2">v0.6.0</div>
          <div class="py-2">v0.5.0</div>
          <div class="py-2">v0.4.0</div>
          <div class="py-2">v0.3.0</div>
          <div class="py-2">v0.2.0</div>
          <div class="py-2">v0.1.0</div>
        </div>
      </div>'.html_safe
    end
  end

  # @label Vertical
  # Vertical scrolling with long content
  def vertical
    render(Shadcn::ScrollAreaComponent.new(orientation: :vertical, class_name: "h-[200px] w-[350px] rounded-md border p-4")) do
      '<div>
        <h3 class="font-semibold mb-4">Lorem Ipsum</h3>
        <p class="text-sm text-muted-foreground mb-4">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
        </p>
        <p class="text-sm text-muted-foreground mb-4">
          Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        </p>
        <p class="text-sm text-muted-foreground mb-4">
          Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.
        </p>
        <p class="text-sm text-muted-foreground">
          Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.
        </p>
      </div>'.html_safe
    end
  end

  # @label Horizontal
  # Horizontal scrolling artwork gallery
  def horizontal
    render(Shadcn::ScrollAreaComponent.new(orientation: :horizontal, class_name: "w-96 whitespace-nowrap rounded-md border")) do
      '<div class="flex w-max space-x-4 p-4">
        <figure class="shrink-0">
          <div class="overflow-hidden rounded-md">
            <img src="https://images.unsplash.com/photo-1588345921523-c2dcdb7f1dcd?w=300&dpr=2&q=80" alt="Photo 1" class="aspect-[3/4] h-fit w-fit object-cover" width="300" height="400" />
          </div>
          <figcaption class="pt-2 text-xs text-muted-foreground">Photo 1</figcaption>
        </figure>
        <figure class="shrink-0">
          <div class="overflow-hidden rounded-md">
            <img src="https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?w=300&dpr=2&q=80" alt="Photo 2" class="aspect-[3/4] h-fit w-fit object-cover" width="300" height="400" />
          </div>
          <figcaption class="pt-2 text-xs text-muted-foreground">Photo 2</figcaption>
        </figure>
        <figure class="shrink-0">
          <div class="overflow-hidden rounded-md">
            <img src="https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?w=300&dpr=2&q=80" alt="Photo 3" class="aspect-[3/4] h-fit w-fit object-cover" width="300" height="400" />
          </div>
          <figcaption class="pt-2 text-xs text-muted-foreground">Photo 3</figcaption>
        </figure>
        <figure class="shrink-0">
          <div class="overflow-hidden rounded-md">
            <img src="https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=300&dpr=2&q=80" alt="Photo 4" class="aspect-[3/4] h-fit w-fit object-cover" width="300" height="400" />
          </div>
          <figcaption class="pt-2 text-xs text-muted-foreground">Photo 4</figcaption>
        </figure>
        <figure class="shrink-0">
          <div class="overflow-hidden rounded-md">
            <img src="https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=300&dpr=2&q=80" alt="Photo 5" class="aspect-[3/4] h-fit w-fit object-cover" width="300" height="400" />
          </div>
          <figcaption class="pt-2 text-xs text-muted-foreground">Photo 5</figcaption>
        </figure>
      </div>'.html_safe
    end
  end

  # @label Both Directions
  # Scrollable in both vertical and horizontal directions
  def both_directions
    render(Shadcn::ScrollAreaComponent.new(orientation: :both, class_name: "h-[300px] w-[400px] rounded-md border")) do
      '<table class="w-max border-collapse">
        <thead>
          <tr class="border-b">
            <th class="px-4 py-2 text-left font-medium">Column 1</th>
            <th class="px-4 py-2 text-left font-medium">Column 2</th>
            <th class="px-4 py-2 text-left font-medium">Column 3</th>
            <th class="px-4 py-2 text-left font-medium">Column 4</th>
            <th class="px-4 py-2 text-left font-medium">Column 5</th>
            <th class="px-4 py-2 text-left font-medium">Column 6</th>
          </tr>
        </thead>
        <tbody>
          <tr class="border-b"><td class="px-4 py-2">Row 1, Cell 1</td><td class="px-4 py-2">Row 1, Cell 2</td><td class="px-4 py-2">Row 1, Cell 3</td><td class="px-4 py-2">Row 1, Cell 4</td><td class="px-4 py-2">Row 1, Cell 5</td><td class="px-4 py-2">Row 1, Cell 6</td></tr>
          <tr class="border-b"><td class="px-4 py-2">Row 2, Cell 1</td><td class="px-4 py-2">Row 2, Cell 2</td><td class="px-4 py-2">Row 2, Cell 3</td><td class="px-4 py-2">Row 2, Cell 4</td><td class="px-4 py-2">Row 2, Cell 5</td><td class="px-4 py-2">Row 2, Cell 6</td></tr>
          <tr class="border-b"><td class="px-4 py-2">Row 3, Cell 1</td><td class="px-4 py-2">Row 3, Cell 2</td><td class="px-4 py-2">Row 3, Cell 3</td><td class="px-4 py-2">Row 3, Cell 4</td><td class="px-4 py-2">Row 3, Cell 5</td><td class="px-4 py-2">Row 3, Cell 6</td></tr>
          <tr class="border-b"><td class="px-4 py-2">Row 4, Cell 1</td><td class="px-4 py-2">Row 4, Cell 2</td><td class="px-4 py-2">Row 4, Cell 3</td><td class="px-4 py-2">Row 4, Cell 4</td><td class="px-4 py-2">Row 4, Cell 5</td><td class="px-4 py-2">Row 4, Cell 6</td></tr>
          <tr class="border-b"><td class="px-4 py-2">Row 5, Cell 1</td><td class="px-4 py-2">Row 5, Cell 2</td><td class="px-4 py-2">Row 5, Cell 3</td><td class="px-4 py-2">Row 5, Cell 4</td><td class="px-4 py-2">Row 5, Cell 5</td><td class="px-4 py-2">Row 5, Cell 6</td></tr>
          <tr class="border-b"><td class="px-4 py-2">Row 6, Cell 1</td><td class="px-4 py-2">Row 6, Cell 2</td><td class="px-4 py-2">Row 6, Cell 3</td><td class="px-4 py-2">Row 6, Cell 4</td><td class="px-4 py-2">Row 6, Cell 5</td><td class="px-4 py-2">Row 6, Cell 6</td></tr>
          <tr class="border-b"><td class="px-4 py-2">Row 7, Cell 1</td><td class="px-4 py-2">Row 7, Cell 2</td><td class="px-4 py-2">Row 7, Cell 3</td><td class="px-4 py-2">Row 7, Cell 4</td><td class="px-4 py-2">Row 7, Cell 5</td><td class="px-4 py-2">Row 7, Cell 6</td></tr>
          <tr class="border-b"><td class="px-4 py-2">Row 8, Cell 1</td><td class="px-4 py-2">Row 8, Cell 2</td><td class="px-4 py-2">Row 8, Cell 3</td><td class="px-4 py-2">Row 8, Cell 4</td><td class="px-4 py-2">Row 8, Cell 5</td><td class="px-4 py-2">Row 8, Cell 6</td></tr>
          <tr class="border-b"><td class="px-4 py-2">Row 9, Cell 1</td><td class="px-4 py-2">Row 9, Cell 2</td><td class="px-4 py-2">Row 9, Cell 3</td><td class="px-4 py-2">Row 9, Cell 4</td><td class="px-4 py-2">Row 9, Cell 5</td><td class="px-4 py-2">Row 9, Cell 6</td></tr>
          <tr class="border-b"><td class="px-4 py-2">Row 10, Cell 1</td><td class="px-4 py-2">Row 10, Cell 2</td><td class="px-4 py-2">Row 10, Cell 3</td><td class="px-4 py-2">Row 10, Cell 4</td><td class="px-4 py-2">Row 10, Cell 5</td><td class="px-4 py-2">Row 10, Cell 6</td></tr>
        </tbody>
      </table>'.html_safe
    end
  end

  # @label Scrollbar Types
  # Different scrollbar visibility behaviors
  # @param type select { choices: [auto, always, scroll, hover] }
  def scrollbar_types(type: :hover)
    render(Shadcn::ScrollAreaComponent.new(orientation: :vertical, type: type.to_sym, class_name: "h-48 w-64 rounded-md border p-4")) do
      '<div>
        <h4 class="mb-2 text-sm font-medium">Scrollbar Type: ' + type.to_s.capitalize + '</h4>
        <p class="text-sm text-muted-foreground mb-2">
          This scroll area uses the "' + type.to_s + '" scrollbar type.
        </p>
        <ul class="text-sm space-y-1">
          <li>Item 1</li>
          <li>Item 2</li>
          <li>Item 3</li>
          <li>Item 4</li>
          <li>Item 5</li>
          <li>Item 6</li>
          <li>Item 7</li>
          <li>Item 8</li>
          <li>Item 9</li>
          <li>Item 10</li>
          <li>Item 11</li>
          <li>Item 12</li>
        </ul>
      </div>'.html_safe
    end
  end

  # @label Code Block
  # Scroll area containing code with syntax
  def code_block
    render(Shadcn::ScrollAreaComponent.new(class_name: "h-64 w-full max-w-md rounded-md border")) do
      '<pre class="p-4 text-sm"><code>import { ScrollArea } from "@/components/ui/scroll-area"

export function ScrollAreaDemo() {
  return (
    &lt;ScrollArea className="h-72 w-48 rounded-md border"&gt;
      &lt;div className="p-4"&gt;
        &lt;h4 className="mb-4 text-sm font-medium leading-none"&gt;
          Tags
        &lt;/h4&gt;
        {Array.from({ length: 50 }).map((_, i) =&gt; (
          &lt;div key={i} className="text-sm"&gt;
            v1.2.0-beta.{i}
          &lt;/div&gt;
        ))}
      &lt;/div&gt;
    &lt;/ScrollArea&gt;
  )
}</code></pre>'.html_safe
    end
  end
end
