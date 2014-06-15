module ItemsHelper
  PER_PAGE = 30

  def add_tag(str, item)
    item.tag_list.add(str)
    item.save
    item.reload
  end

  def search(query)
    quiche_type = query[:quiche_type]
    member_flag = query[:menber]
    page = query[:page] || 1
    text = query[:text]
    user_id = query[:user_id]
    reader_ids = query[:reader_ids]
    reader_and_flag = query[:reader_and]
    tag_ids = query[:tag_ids]
    tag_and_flag = query[:tag_and]
    from_date = query[:from]
    until_date = query[:until]

    result = Item.search do
      order_by :created_at, :desc
      with(:quiche_type, quiche_type)

      unless member_flag.nil?
        if member_flag
          without(:private, true)
        end
      end

      paginate(page: page, per_page: PER_PAGE )

      unless text.nil?
        fulltext text
      end

      unless user_id.nil?
        with(:user_id, user_id)
      end

      unless reader_and_flag.nil?
        if reader_and_flag
          reader_ids.each do |id|
            with(:readers, id)
          end
        else
          any_of do
            with(:readers, reader_ids)
          end
        end
      end

      unless tag_and_flag.nil?
        if tag_and_flag
          tag_ids.each do |id|
            with(:tags, id)
          end
        else
          any_of do
            with(:tags, tag_ids)
          end
        end
      end

      unless from_date.nil?
        with(:created_at).greater_than(from_date)
      end

      unless until_date.nil?
        with(:created_at).less_than(until_date)
      end
    end

    result.results
  end
end
