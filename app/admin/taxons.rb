ActiveAdmin.register Taxon, :alias => I18n.t(:taxon) do
  menu :parent => "Classements"
  controller.authorize_resource

  filter :name
  controller do
    def current_ability
      @current_ability ||= AdminAbility.new(current_admin_user)
    end
    
    def end_of_association_chain
      if action_name == "index"
        return Taxon.order('lft asc ,rgt asc')
      end
     return super
    end

  end

  form :partial => "form"
  index do
    column :id
    column :name do |t|
      div :class => "tab#{t.level}" do
        if t.level > 0
          span t.parent.name
          span "&rarr;".html_safe
        end

        b t.name
      end
    end
    column "Action" do |t|
      if !t.root?
        unless t.left_sibling.nil?
          span link_to "Remonter", move_up_admin_taxon_path(t)
        end
        unless t.right_sibling.nil?
          span link_to "Descendre", move_down_admin_taxon_path(t) 
        end
      end
    end
    default_actions

  end

  member_action :move_down do
    taxon = Taxon.find(params[:id])
    taxon.move_right
    redirect_to admin_taxons_path

  end
  member_action :move_up do
    taxon = Taxon.find(params[:id])
    taxon.move_left
    redirect_to admin_taxons_path
  end


  
end
