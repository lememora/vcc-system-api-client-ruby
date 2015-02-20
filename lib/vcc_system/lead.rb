module VCCSystem
  module Lead

    LEAD_ADD_ERRORS = {
      "1" => "Invalid campaign GUID",
      "2" => "Invalid phone number format",
      "3" => "System error"
    }

    def vcc_lead_add(campaign_guid, phone, reference_id)
      phone = phone.to_s.gsub(/[^\d]/, '')
      raise "Phone number format required: 1XXXXXXXXXX" unless phone.match(/^[\d]{11}$/)

      response = self.execute __method__, project_guid: self.project_guid,
        campaign_guid: campaign_guid,
        phone: phone,
        reference_id: reference_id

      parsed = begin
        self.parse_response!(response, :xml)
      rescue RuntimeError => e
        raise "Invalid response for #{__method__} (#{e.message})"
      end

      return parsed[:items].first if parsed[:status] == "0"

      raise(LEAD_ADD_ERRORS[(parsed[:status])] || "Failed (status: #{parsed[:status]})")
    end

    def vcc_lead_del(lead_guid)
      response = self.execute __method__, project_guid: self.project_guid,
        guid: lead_guid

      parsed = begin
        self.parse_response!(response, :xml)
      rescue RuntimeError => e
        raise "Invalid response for #{__method__} (#{e.message})"
      end

      parsed[:status] == "0" || raise("Failed (status: #{parsed[:status]})")
    end

    def vcc_lead_list(campaign_guid)
      response = self.execute __method__, project_guid: self.project_guid,
        guid: campaign_guid

      parsed = begin
        self.parse_response!(response)
      rescue RuntimeError => e
        raise "Invalid response for #{__method__} (#{e.message})"
      end
    end

    protected

    def vcc_lead_add_single()
    end

    # https://nbvcc.giisystems.com/vcc/vcc_leads_add.php?campaign_guid=abcd&phone[]=123&reference_id[]=1&phone[]=234&reference_id[]=2
    def vcc_lead_add_multiple()
    end

  end
end
