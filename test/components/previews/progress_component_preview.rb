# frozen_string_literal: true

# @label Progress
# @display bg_color "#ffffff"
class ProgressComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic progress bar at 60%
  def default
    render(Shadcn::ProgressComponent.new(value: 60))
  end

  # @label All Values
  # Shows progress at different values
  # @param value number
  def values(value: 50)
    render(Shadcn::ProgressComponent.new(value: value))
  end

  # @label Zero Percent
  # Progress bar at 0%
  def zero
    render(Shadcn::ProgressComponent.new(value: 0))
  end

  # @label Twenty Five Percent
  # Progress bar at 25%
  def twenty_five
    render(Shadcn::ProgressComponent.new(value: 25))
  end

  # @label Fifty Percent
  # Progress bar at 50%
  def fifty
    render(Shadcn::ProgressComponent.new(value: 50))
  end

  # @label Seventy Five Percent
  # Progress bar at 75%
  def seventy_five
    render(Shadcn::ProgressComponent.new(value: 75))
  end

  # @label Complete
  # Progress bar at 100%
  def complete
    render(Shadcn::ProgressComponent.new(value: 100))
  end

  # @label Indeterminate
  # Loading state with animation
  def indeterminate
    render(Shadcn::ProgressComponent.new(indeterminate: true))
  end

  # @label Custom Max
  # Progress with custom max value (30 out of 50)
  def custom_max
    <<~HTML.html_safe
      <div class="space-y-2">
        <div class="flex justify-between text-sm">
          <span>30 / 50</span>
          <span>60%</span>
        </div>
        #{render(Shadcn::ProgressComponent.new(value: 30, max: 50))}
      </div>
    HTML
  end

  # @label With Label
  # Progress bar with descriptive label
  def with_label
    <<~HTML.html_safe
      <div class="space-y-2">
        <div class="flex justify-between text-sm">
          <span class="text-muted-foreground">Uploading...</span>
          <span class="font-medium">75%</span>
        </div>
        #{render(Shadcn::ProgressComponent.new(value: 75))}
      </div>
    HTML
  end

  # @label Multiple Steps
  # Example showing progress through multiple steps
  def multiple_steps
    <<~HTML.html_safe
      <div class="space-y-4">
        <div class="space-y-2">
          <div class="flex justify-between text-sm">
            <span class="text-muted-foreground">Step 1: Basic Information</span>
            <span class="font-medium text-green-600">Complete</span>
          </div>
          #{render(Shadcn::ProgressComponent.new(value: 100))}
        </div>
        <div class="space-y-2">
          <div class="flex justify-between text-sm">
            <span class="text-muted-foreground">Step 2: Contact Details</span>
            <span class="font-medium">50%</span>
          </div>
          #{render(Shadcn::ProgressComponent.new(value: 50))}
        </div>
        <div class="space-y-2">
          <div class="flex justify-between text-sm">
            <span class="text-muted-foreground">Step 3: Preferences</span>
            <span class="font-medium text-gray-400">Not started</span>
          </div>
          #{render(Shadcn::ProgressComponent.new(value: 0))}
        </div>
      </div>
    HTML
  end

  # @label File Upload
  # Progress bar styled for file upload
  def file_upload
    <<~HTML.html_safe
      <div class="space-y-3 rounded-lg border p-4">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-3">
            <div class="rounded-md bg-primary/10 p-2">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-primary">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                <polyline points="14 2 14 8 20 8"/>
              </svg>
            </div>
            <div>
              <p class="text-sm font-medium">document.pdf</p>
              <p class="text-xs text-muted-foreground">2.4 MB of 3.2 MB</p>
            </div>
          </div>
          <span class="text-sm font-medium">75%</span>
        </div>
        #{render(Shadcn::ProgressComponent.new(value: 75))}
      </div>
    HTML
  end

  # @label Loading State
  # Indeterminate progress for loading
  def loading
    <<~HTML.html_safe
      <div class="space-y-2">
        <p class="text-sm text-muted-foreground">Loading your data...</p>
        #{render(Shadcn::ProgressComponent.new(indeterminate: true))}
      </div>
    HTML
  end
end
