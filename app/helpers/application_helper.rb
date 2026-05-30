module ApplicationHelper
  def page_title(title = nil)
    if title.present?
      "#{title} | Çivit"
    else
      "Çivit | Twitter Clone"
    end
  end

  def avatar_initials(user)
    user.username[0..1].upcase
  end

  def avatar_gradient(user)
    gradients = [
      "from-violet-500 to-fuchsia-500",
      "from-emerald-400 to-cyan-500",
      "from-rose-400 to-pink-500",
      "from-amber-400 to-orange-500",
      "from-sky-400 to-blue-500",
      "from-indigo-400 to-purple-500",
    ]
    gradients[user.id % gradients.length]
  end
end
