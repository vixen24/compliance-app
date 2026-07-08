module AvatarsHelper
  AVATAR_COLORS = [
    { bg: "from-red-100 to-red-200", text: "text-red-700" },
    { bg: "from-blue-100 to-blue-200", text: "text-blue-700" },
    { bg: "from-sky-100 to-sky-200", text: "text-sky-700" },
    { bg: "from-purple-100 to-purple-200", text: "text-purple-700" },
    { bg: "from-pink-100 to-pink-200", text: "text-pink-700" },
    { bg: "from-indigo-100 to-indigo-200", text: "text-indigo-700" },
    { bg: "from-mauve-100 to-mauve-200", text: "text-mauve-700" },
    { bg: "from-teal-100 to-teal-200", text: "text-teal-700" },
    { bg: "from-rose-100 to-rose-200", text: "text-rose-700" }
  ].freeze

  def avatar_color(user)
    index = user.id % AVATAR_COLORS.length
    AVATAR_COLORS[index]
  end

  def default_avatar_color
    { bg: "bg-gray-100", text: "text-gray-700" }
  end
end
