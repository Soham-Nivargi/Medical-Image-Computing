function [obj] = compute_obj(distances, memberships)
    obj = sum(distances.*memberships, "all");
end