namespace :backfill_groups do
  desc 'Backfill group ownership for existing groups with the first member as the owner'
  task ownership: :environment do
    Group.where(owner_id: nil).find_each do |group|
      owner = User.joins(:groups).where(groups: { id: group.id }).first
      owner ||= User.find_by(email: 'admin@example.com')

      if owner
        group.update(owner: owner)
        puts "Backfilled owner for group #{group.id} (#{group.name}) with user #{owner.id} (#{owner.name})"
      else
        puts "No members found for group #{group.id} (#{group.name}), skipping owner backfill"
      end
    end
  end
end
