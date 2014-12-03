module Lita
  module Handlers
    class Retro < Handler
      route /retro\s+(?::\)|\+)\s+(.+)/i, :add_good, command: true, help: {
        t("help.add_good_key") => t("help.add_good_value")
      }

      route /retro\s+(?::\(|\-)\s+(.+)/i, :add_bad, command: true, help: {
        t("help.add_bad_key") => t("help.add_bad_value")
      }

      route /retro\s+(?::\||\=)\s+(.+)/i, :add_neutral, command: true, help: {
        t("help.add_neutral_key") => t("help.add_neutral_value")
      }

      route /retro\s+list/i, :list, command: true, help: {
        "retro list" => t("help.list_value")
      }

      route /retro\s+clear/i, :clear, command: true, restrict_to: :retro_admins, help: {
        "retro clear" => t("help.clear_value")
      }

      def add_bad(response)
        add_type("bad", response)
      end

      def add_good(response)
        add_type("good", response)
      end

      def add_neutral(response)
        add_type("neutral", response)
      end

      def list(response)
        topics = [
          list_type("good"),
          list_type("bad"),
          list_type("neutral")
        ].compact

        if topics.empty?
          response.reply(t("no_topics"))
        else
          response.reply(topics.join("\n"))
        end
      end

      def clear(response)
        %w(good bad neutral).map do |type|
          redis.smembers(type).each { |id| redis.del("#{type}:#{id}") }
          redis.del(type)
        end

        response.reply(t("clear"))
      end

      private

      def add_type(type, response)
        redis.sadd("#{type}:#{response.user.id}", response.matches[0][0])
        redis.sadd("#{type}", response.user.id)
        response.reply(t("added", type: type))
      end

      def list_type(type)
        user_ids = redis.smembers(type)
        return if user_ids.empty?

        topics = []

        user_ids.each do |user_id|
          user = User.find_by_id(user_id)
          next unless user

          redis.smembers("#{type}:#{user.id}").each do |topic|
            topics << t("topic", type: type.capitalize, name: user.name, topic: topic)
          end
        end

        topics.join("\n")
      end
    end

    Lita.register_handler(Retro)
  end
end

